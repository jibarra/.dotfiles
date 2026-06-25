import { homedir } from "os"
import { readFileSync, writeFileSync } from "fs"
import { join } from "path"

// @mohak34/opencode-notifier passes sound paths straight to fs.existsSync with
// no expansion, so ~ paths never match. This expands ~ / ~/... to the home
// directory (any other value is assumed to already be absolute), writes a
// resolved copy of the config, and points the notifier at it via
// OPENCODE_NOTIFIER_CONFIG_PATH (which it reads per-event).
//
// The resolved copy lives in the same directory as the source so the notifier's
// state file (derived from the config dir) keeps its existing location.
const SOURCE = join(homedir(), ".config", "opencode", "opencode-notifier.json")
const RESOLVED = join(homedir(), ".config", "opencode", ".opencode-notifier.resolved.json")

function expandPath(value) {
  if (typeof value !== "string" || value.length === 0) return value
  if (value === "~") return homedir()
  if (value.startsWith("~/")) return join(homedir(), value.slice(2))
  return value
}

export const NotifierPathResolver = async () => {
  try {
    const config = JSON.parse(readFileSync(SOURCE, "utf-8"))
    if (config.sounds && typeof config.sounds === "object") {
      for (const key of Object.keys(config.sounds)) {
        config.sounds[key] = expandPath(config.sounds[key])
      }
    }
    writeFileSync(RESOLVED, JSON.stringify(config, null, 2))
    process.env.OPENCODE_NOTIFIER_CONFIG_PATH = RESOLVED
  } catch (error) {
    console.error("notifier-path-resolver: failed to resolve sound paths", error)
  }
  return {}
}
