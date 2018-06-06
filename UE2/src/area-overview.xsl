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

	<!-- Insert additional templates here -->


</xsl:stylesheet>
