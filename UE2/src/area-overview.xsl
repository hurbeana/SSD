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
        <xsl:apply-templates select="//area"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="sequence">
    <xsl:if test="exists(input)">
      <p>
        <b>Input: </b>
        <xsl:value-of select="sum(input/item)"/> Items
      </p>
    </xsl:if>
    <table>
      <tr>
        <xsl:for-each select="*">
            <xsl:choose>
              <xsl:when test="exists(@name)">
                <th>
                  <xsl:value-of select="substring(local-name(),1,1)"/>:
                  <xsl:value-of select="@name"/>
                </th>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test=".[local-name() = 'ref']">
                    <xsl:variable name="refvar" select="@id"/>
                    <th>
                    s:
                    <xsl:choose>
                      <xsl:when test="exists(//slot[@id = $refvar]/@name)">
                        <xsl:value-of select="//slot[@id = $refvar]/@name"/>
                      </xsl:when>
                      <xsl:otherwise>slot</xsl:otherwise>
                    </xsl:choose>
                    </th>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test=".[local-name() != 'input'] and .[local-name() != 'output']">
                      <th>
                      <xsl:value-of select="local-name()"/>
                      </th>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:for-each>
      </tr>
    <tr>
      <xsl:apply-templates select="./*" />
    </tr>
    </table>
    <xsl:if test="exists(output)">
      <p>
        <b>Output: </b>
        <xsl:value-of select="sum(output/item)"/> Items
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="area">
    <h2>
      <xsl:value-of select="@name"/>
    </h2>
    <xsl:call-template name="sequence"/>
  </xsl:template>

  <xsl:template match="slot">
    <td style="vertical-align:top">
      <xsl:call-template name="sequence"/>
    </td>
  </xsl:template>

  <xsl:template match="conveyor | generator | machine | turntable">
    <td style="vertical-align:top">
      Cost:
      <xsl:value-of select="cost"/>
      <br/>
      Time:
      <xsl:value-of select="time"/>
    </td>
  </xsl:template>

  <xsl:template match="ref">
    <xsl:variable name="refvar" select="@id"/>
    <xsl:apply-templates select="//slot[@id = $refvar]"/>
  </xsl:template>

  <!--xsl:template match="input"/>
  <xsl:template match="output"/>
  <xsl:template match="item"/-->
  <xsl:template match="*"/>
</xsl:stylesheet>
