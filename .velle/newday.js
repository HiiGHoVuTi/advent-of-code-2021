
const current = readJSON(".velle/progress.json");

const dayCount = current.day + 1;

log("Welcome to day " + dayCount + " ! Creating file...");
  
const filename = "day-" + dayCount    + ".hs";
const oldfile  = "day-" + current.day + ".hs";

cpfile("template.hs", filename);
const contents = readFile(filename)
  .replace("???", filename)
  .replace("???", filename);
writeToFile(filename, contents);

exec("git add " + oldfile);
exec("git stage .");
exec("git commit -m \"day " + current.day + "\"");

writeJSON(".velle/progress.json", {
  day: dayCount
});

