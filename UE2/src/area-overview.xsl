<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="html"/>

  <xsl:template match="system">
    <html>
      <head>
        <title>System - Area Overview</title>
        <style>
          table {
          font-family: Arial, Helvetica, sans-serif;
          border-collapse: collapse;
          width: 100%;
          }

          td, th {
          border: 1px solid #ddd;
          padding: 8px;
          }

          tr:hover {background-color: #ddd;}

          th {
          padding-top: 12px;
          padding-bottom: 12px;
          text-align: left;
          background-color: #f4ce42;
          color: white;
          }
        </style>
      </head>
      <body>
        <h1>Area Overview</h1>
        <xsl:call-template name="sequence"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="sequence">
    <xsl:for-each select="area">
      <h2>
        <xsl:value-of select="@name"/>
      </h2>
      <table>
        <tr>
          <xsl:for-each select="slot">
            <th>s:
              <xsl:value-of select="@name"/>
            </th>
          </xsl:for-each>
        </tr>
        <tr>
          <xsl:for-each select="slot">
            <td>
              <xsl:if test="exists(input)">
                <p>
                  <b>Input:</b>
                  <xsl:value-of select="sum(input/item)"/> Items
                </p>
              </xsl:if>
              <table>
                <xsl:for-each select="./*">
                  <xsl:choose>
                    <xsl:when test="@name">
                      <th>
                        <xsl:value-of select="substring(@name,1,1)"/>:
                        <xsl:value-of select="@name"/>
                      </th>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="../ref">
                          <xsl:variable name="refvar" select="@id"/>
                          <th>
                            <xsl:value-of select="//slot[@id = $refvar]::@name"/>
                          </th>
                        </xsl:when>
                        <xsl:otherwise>NO REF</xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </table>
            </td>
          </xsl:for-each>
        </tr>
      </table>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
