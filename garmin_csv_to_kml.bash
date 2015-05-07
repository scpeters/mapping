#!/bin/bash
# Example kml file from
# https://developers.google.com/kml/documentation/kml_tut#paths
CSV_NAME=$1
cat <<END
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Paths</name>
    <description>Examples of paths. Note that the tessellate tag is by default
      set to 0. If you want to create tessellated lines, they must be authored
      (or edited) directly in KML.</description>
    <Style id="yellowLineGreenPoly">
      <LineStyle>
        <color>7f00ffff</color>
        <width>4</width>
      </LineStyle>
      <PolyStyle>
        <color>7f00ff00</color>
      </PolyStyle>
    </Style>
    <Placemark>
      <name>Absolute Extruded</name>
      <description>Transparent green wall with yellow outlines</description>
      <styleUrl>#yellowLineGreenPoly</styleUrl>
      <LineString>
        <extrude>1</extrude>
        <tessellate>1</tessellate>
        <altitudeMode>absolute</altitudeMode>
        <coordinates>
END
# Look for line that starts with 'trkpt'
trkpt_line=`grep -n ^trkpt ${CSV_NAME} | sed -e 's@:.*@@'`
# Delete that line and all lines before that (metadata)
# Delete the following line as well (csv header labels)
# Delete the first two columns (ID, trksegID)
# Delete all trailing commas
# We also need to switch columns 1 and 2
sed "1,${trkpt_line}d" ${CSV_NAME} \
  | sed '1d' \
  | sed -e 's@^[0-9]*,[0-9]*,@@' \
        -e 's@,,,*@@' \
        -e 's@^\([0-9\.\-]*\),\([0-9\.\-]*\),@\2,\1,@'
# This is a quick hack, may not be robust
cat <<END
        </coordinates>
      </LineString>
    </Placemark>
  </Document>
</kml>
END

