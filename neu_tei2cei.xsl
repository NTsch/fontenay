<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <!--TEI als default namespace aus der Quelle übernehmen-->
    <!--<xsl:import-schema schema-location='cei.xsd'/>-->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="teiCorpus">
        <cei>
            <xsl:apply-templates/>
        </cei>
    </xsl:template>

    <xsl:template match="teiCorpus/teiHeader//element()">
        <xsl:element name="cei:{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="teiCorpus/teiHeader/sourceDesc">
        <xsl:apply-templates select=". and ../editionStmt"/>
    </xsl:template>

    <xsl:template match="TEI">
        <cei:text>
            <cei:front>
                <cei:sourceDesc>
                    <cei:sourceDescVolltext>
                        <cei:bibl/>
                    </cei:sourceDescVolltext>
                    <cei:sourceDescRegest>
                        <cei:bibl/>
                    </cei:sourceDescRegest>
                </cei:sourceDesc>
            </cei:front>
            <cei:body>
                <cei:idno>
                    <xsl:text>Fontenay-ID:</xsl:text>
                    <xsl:value-of select="count(preceding::TEI) + 1"/>
                    <!--automatische Nummerierung-->
                </cei:idno>
                <cei:chDesc>
                    <cei:abstract>
                        <xsl:value-of select="teiHeader/profileDesc/abstract"/>
                    </cei:abstract>
                    <cei:issued>
                        <xsl:apply-templates select="teiHeader/profileDesc/creation"/>
                    </cei:issued>
                    <xsl:for-each select="teiHeader/fileDesc/sourceDesc/listWit/witness">
                        <xsl:if test="@n = 'A'">
                            <cei:witnessOrig>
                                <xsl:apply-templates select="."/>
                            </cei:witnessOrig>
                        </xsl:if>
                    </xsl:for-each>
                    <cei:witListPar>
                        <xsl:for-each select="teiHeader/fileDesc/sourceDesc/listWit/witness">
                            <xsl:if test="not(@n = 'A')">
                                <cei:witness>
                                    <xsl:apply-templates select="."/>
                                </cei:witness>
                            </xsl:if>
                        </xsl:for-each>
                    </cei:witListPar>
                    <cei:diplomaticAnalysis>
                        <cei:listBibl>
                            <xsl:for-each select="teiHeader/fileDesc/sourceDesc/listBibl/bibl">
                                <cei:bibl>
                                    <!--Attribute überprüfen!-->
                                    <xsl:apply-templates/>
                                </cei:bibl>
                            </xsl:for-each>
                        </cei:listBibl>
                        <cei:listBiblRegest>
                            <cei:bibl/>
                        </cei:listBiblRegest>
                        <cei:listBiblFaksimile>
                            <cei:bibl/>
                        </cei:listBiblFaksimile>
                        <cei:listBiblErw>
                            <cei:bibl/>
                        </cei:listBiblErw>
                        <xsl:if test="teiHeader/profileDesc/creation/date/note">
                            <cei:p>
                                <xsl:apply-templates
                                    select="teiHeader/profileDesc/creation/date/note"/>
                            </cei:p>
                        </xsl:if>
                        <cei:quoteOriginaldatierung/>
                        <cei:nota/>
                        <cei:listBiblEdition>
                            <cei:bibl/>
                        </cei:listBiblEdition>
                    </cei:diplomaticAnalysis>
                    <cei:lang_MOM/>
                </cei:chDesc>
                <cei:tenor>
                    <xsl:apply-templates select="text/body/div1"/>
                </cei:tenor>
            </cei:body>
            <cei:back>
                <cei:persName/>
                <cei:placeName type="Region"/>
                <cei:index indexName="illurk-vocabulary" lemma="Initials"/>
                <cei:index indexName="illurk-vocabulary" lemma="Historiated"/>
                <cei:index indexName="illurk-vocabulary" lemma="WithAdditionalColours"/>
                <cei:index indexName="illurk-vocabulary" lemma="ExecutionPainted"/>
                <cei:index indexName="illurk-vocabulary" lemma="DD-nh-Initials"/>
                <cei:divNotes>
                    <cei:note/>
                </cei:divNotes>
                <cei:class/>
            </cei:back>
        </cei:text>
    </xsl:template>

    <xsl:template
        match="abbr | add | additions | addName | app | author | bibl | choice | corr | ex | expan | foreign | gap | geogName | handShift | height | lem | listBibl | name | note | orgName | p | persName | placeName | roleName | sic | soCalled | surName | teiHeader | title | width">
        <xsl:element name="cei:{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template
        match="damage | figure | graphic | hi | lb | pb | pc | rdg | seg | space | supplied | w">
        <xsl:element name="cei:{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <!--Faksimile-Informationen?-->
        </xsl:element>
    </xsl:template>

    <xsl:template match="date">
        <cei:date>
            <xsl:attribute name="value">
                <xsl:value-of select="format-date(./@when, '[Y0001][M01][D01]')"/>
            </xsl:attribute>
            <xsl:value-of select="./text()"/>
        </cei:date>
    </xsl:template>

    <xsl:template match="q">
        <cei:quote>
            <xsl:apply-templates/>
        </cei:quote>
    </xsl:template>

    <xsl:template match="witness">
        <xsl:choose>
            <xsl:when test="./@n = 'A'">
                <cei:traditioForm>Original</cei:traditioForm>
            </xsl:when>
            <xsl:otherwise>
                <cei:traditioForm>
                    <xsl:value-of select="msDesc/p"/>
                </cei:traditioForm>
            </xsl:otherwise>
        </xsl:choose>
        <cei:archIdentifier>
            <cei:settlement>
                <xsl:apply-templates select="msDesc/msIdentifier/settlement"/>
            </cei:settlement>
            <cei:arch>
                <xsl:apply-templates select="msDesc/msIdentifier/repository"/>
            </cei:arch>
            <cei:idno>
                <xsl:apply-templates select="msDesc/msIdentifier/idno"/>
            </cei:idno>
        </cei:archIdentifier>
        <cei:physicalDesc>
            <cei:material>
                <xsl:value-of select="msDesc/physDesc/objectDesc/supportDesc/support/@material"/>
                <xsl:value-of select="msDesc/physDesc/objectDesc/supportDesc/support/p"/>
            </cei:material>
            <cei:dimensions>
                <xsl:attribute name="type">
                    <xsl:value-of
                        select="msDesc/physDesc/objectDesc/supportDesc/extent/dimensions[1]/@type"/>
                </xsl:attribute>
                <xsl:attribute name="unit">
                    <xsl:value-of
                        select="msDesc/physDesc/objectDesc/supportDesc/extent/dimensions[1]/@unit"/>
                </xsl:attribute>
                <xsl:apply-templates
                    select="msDesc/physDesc/objectDesc/supportDesc/extent/dimensions[1]"/>
            </cei:dimensions>
            <cei:dimensions>
                <xsl:attribute name="type">
                    <xsl:value-of
                        select="msDesc/physDesc/objectDesc/supportDesc/extent/dimensions[2]/@type"/>
                </xsl:attribute>
                <xsl:attribute name="unit">
                    <xsl:value-of
                        select="msDesc/physDesc/objectDesc/supportDesc/extent/dimensions[2]/@unit"/>
                </xsl:attribute>
                <xsl:apply-templates
                    select="msDesc/physDesc/objectDesc/supportDesc/extent/dimensions[2]"/>
            </cei:dimensions>
            <cei:condition/>
            <cei:additions>
                <!--additions-Element eingefügt-->
                <xsl:value-of select="msDesc/physDesc/additions"/>
            </cei:additions>
            <cei:p>
                Columns:<xsl:value-of select="msDesc/physDesc/objectDesc/layoutDesc/layout/@columns"/>
                Lines:<xsl:value-of select="msDesc/physDesc/objectDesc/layoutDesc/layout/@writtenLines"/>
                <xsl:value-of select="msDesc/physDesc/objectDesc/layoutDesc/layout"/>
            </cei:p>
            <cei:p>
                <xsl:value-of select="msDesc/physDesc/handDesc"/>
            </cei:p>
        </cei:physicalDesc>
        <cei:auth>
            <!--vorhanden?-->
            <cei:notariusDesc/>
            <cei:sealDesc/>
        </cei:auth>
        <cei:nota/>
        <cei:rubrum/>
        <!--<xsl:value-of select="./text()"/>-->
    </xsl:template>

</xsl:stylesheet>
