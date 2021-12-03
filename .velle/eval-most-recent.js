
const current = readJSON(".velle/progress.json");

exec("./day-" + current.day + ".hs");

