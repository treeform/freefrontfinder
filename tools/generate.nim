import os, json, strformat, strutils, algorithm, tables, urlly

var dbJson = newJArray()
var dbCsv: seq[string]
var dbCsvDup: Table[string, bool]

proc value(line: string): string =
  parseJson(line.split(":", 1)[1]).getStr()

proc valueInt(line: string): int =
  parseJson(line.split(":", 1)[1]).getInt()

proc addFont(name, fontPostScriptName, style: string, weight: int, url, license: string) =
  let
    entry = %*{
      "name": name,
      "ps_name": fontPostScriptName,
      "weight": weight,
      "style": style,
      "license": license,
      "url": url
    }
    entryCsv = &"{fontPostScriptName},\"{url}\",{license}"
  dbJson.add(entry)
  if fontPostScriptName notin dbCsvDup:
    dbCsv.add(entryCsv)
    dbCsvDup[fontPostScriptName] = true
  echo fontPostScriptName

proc processDir(dir: string) =
  for kind, path in walkDir(dir):
    if kind == pcDir:
      let metaDataPath = path / "METADATA.pb"
      if fileExists(metaDataPath):
        let meta = readFile(metaDataPath)
        var name, fontPostScriptName, style, fileName, license: string
        var weight: int
        for line in meta.split("\n"):
          if line.startsWith("  name:"):
            name = line.value()
          if line.startsWith("  post_script_name:"):
            fontPostScriptName =  line.value()
          if line.startsWith("  weight:"):
            weight = line.valueInt()
          if line.startsWith("  style:"):
            style = line.value()
          if line.startsWith("license:"):
            license = line.value()
          if line.startsWith("  filename:"):
            filename = line.value()
          if line.strip() == "}":
            let
              repo = "github.com/google/fonts"
              folder = path.lastPathPart
              sub = path.parentDir.lastPathPart
              url = &"https://{repo}/blob/master/{sub}/{folder}/{encodeUrlComponent(fileName)}?raw=true"
            addFont(name, fontPostScriptName, style, weight, url, license)

# Do google fonts

processDir("/p/googlefonts/ofl")
processDir("/p/googlefonts/ufl")
processDir("/p/googlefonts/apache")

# Do Material Icons

addFont(
  name = "Material Icons",
  fontPostScriptName = "MaterialIcons-Regular",
  style = "normal",
  weight = 400,
  url = "https://github.com/google/material-design-icons/blob/master/font/MaterialIcons-Regular.ttf?raw=true",
  license = "APACHE2"
)

# Write the database

writeFile("fonts.json", $dbJson)
dbCsv.sort()
writeFile("fonts.csv", dbCsv.join("\n"))
