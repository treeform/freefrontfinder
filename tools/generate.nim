import os, json, strformat, strutils, algorithm, tables, urlly

var dbJson = newJArray()
var dbCsv: seq[string]
var dbCsvDup: Table[string, bool]

proc addFont(name, url, license: string) =
  let
    entry = %*{
      "name": name,
      "url": url,
      "license": license
    }
    entryCsv = &"{name},{url},{license}"
  dbJson.add(entry)
  if name notin dbCsvDup:
    dbCsv.add(entryCsv)
    dbCsvDup[name] = true
  echo name

proc processDir(dir, license, baseUrl: string) =
  for file in  walkDirRec(dir):
    if file.endsWith(".ttf"):
      let (path, name, extension) = file.splitFile()
      let path2 = path[dir.len + 1 .. ^1]
      let name2 = encodeUrlComponent(name)
      addFont(
        name = name,
        url = baseUrl.replace("{file}", name2 & extension).replace("{folder}", path2),
        license = license
      )

# Do google fonts

processDir(
  "/p/googlefonts/ofl",
  "OFL",
  "https://github.com/google/fonts/blob/master/ofl/{folder}/{file}?raw=true"
)
processDir(
  "/p/googlefonts/ufl",
  "UFL",
  "https://github.com/google/fonts/blob/master/ufl/{folder}/{file}?raw=true"
)
processDir(
  "/p/googlefonts/apache",
  "APACHE2",
  "https://github.com/google/fonts/blob/master/apache/{folder}/{file}?raw=true"
)

# Do Material Icons

addFont(
  name = "MaterialIcons-Regular",
  url = "https://github.com/google/material-design-icons/blob/master/font/MaterialIcons-Regular.ttf?raw=true",
  license = "APACHE2"
)

# Write the database

writeFile("fonts.json", $dbJson)
dbCsv.sort()
writeFile("fonts.csv", dbCsv.join("\n"))
