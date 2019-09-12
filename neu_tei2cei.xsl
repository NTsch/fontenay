<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <!--TEI als default namespace aus der Quelle übernehmen-->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="teiCorpus">
        <cei>
            <xsl:apply-templates/>
        </cei>
    </xsl:template>

    <xsl:template match="teiCorpus/teiHeader">
        <cei:teiHeader>
            <cei:fileDesc>
                <cei:titleStmt>
                    <cei:title>Recueil des actes de l’abbaye de Fontenay</cei:title>
                    <cei:author>Dominique Stutzmann</cei:author>
                </cei:titleStmt>
                <cei:publicationStmt>
                    <cei:p>Distribué par Telma</cei:p>
                </cei:publicationStmt>
                <cei:sourceDesc>
                    <cei:p>Créé sur MS Word, balisé sur oXgenXML. Version partielle contenant les
                        actes dont les originaux sont conservés.</cei:p>
                </cei:sourceDesc>
            </cei:fileDesc>
        </cei:teiHeader>
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
                    <xsl:text>Fontenay-ID: </xsl:text>
                    <xsl:value-of select="count(preceding::TEI) + 1"/>
                </cei:idno>
                <cei:chDesc>
                    <cei:abstract>
                        <xsl:value-of select="teiHeader/profileDesc/abstract"/>
                    </cei:abstract>
                    <cei:issued>
                        <xsl:if test="teiHeader/fileDesc/sourceDesc/listWit//witness/msDesc/history">
                            <cei:placeName>
                                <xsl:value-of
                                    select="teiHeader/fileDesc/sourceDesc/listWit//witness/msDesc/history"
                                />
                            </cei:placeName>
                        </xsl:if>
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
                        <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listBibl"/>
                        <cei:listBiblRegest>
                            <cei:bibl/>
                        </cei:listBiblRegest>
                        <cei:listBiblFaksimile>
                            <cei:bibl/>
                        </cei:listBiblFaksimile>
                        <cei:listBiblErw>
                            <cei:bibl/>
                        </cei:listBiblErw>
                        <cei:quoteOriginaldatierung/>
                        <cei:nota/>
                        <cei:listBiblEdition>
                            <cei:bibl/>
                        </cei:listBiblEdition>
                        <xsl:if test="teiHeader/profileDesc/creation/date/note">
                            <cei:p>
                                <xsl:value-of select="teiHeader/profileDesc/creation/date/note"/>
                            </cei:p>
                        </xsl:if>
                        <xsl:for-each
                            select=".//witness/msDesc/physDesc/objectDesc/layoutDesc/layout">
                            <cei:p>
                                <xsl:attribute name="n">
                                    <xsl:value-of select="ancestor::witness/@n"/>
                                    <xsl:text>-layout</xsl:text>
                                </xsl:attribute> Columns:<xsl:value-of
                                    select="ancestor::witness/msDesc/physDesc/objectDesc/layoutDesc/layout/@columns"
                                /> Lines:<xsl:value-of
                                    select="ancestor::witness/msDesc/physDesc/objectDesc/layoutDesc/layout/@writtenLines"/>
                                <xsl:apply-templates/>
                            </cei:p>
                        </xsl:for-each>
                        <xsl:for-each select=".//witness/msDesc/physDesc/handDesc">
                            <cei:p>
                                <xsl:attribute name="n">
                                    <xsl:value-of select="ancestor::witness/@n"/>
                                    <xsl:text>-handDesc</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </cei:p>
                        </xsl:for-each>
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
                    <xsl:for-each select=".//witness/msDesc/physDesc/additions">
                        <cei:note>
                            <xsl:attribute name="place">
                                <xsl:value-of select="ancestor::witness/@n"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </cei:note>
                    </xsl:for-each>
                </cei:divNotes>
                <cei:class/>
            </cei:back>
        </cei:text>
    </xsl:template>

    <xsl:template
        match="additions | addName | author | ex | geogName | handShift | height | name | note | orgName | p | persName | placeName | soCalled | surname | teiHeader | title | width">
        <xsl:element name="cei:{local-name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="add | app | damage | figure | hi | lb | lem | pc | space | supplied">
        <xsl:element name="cei:{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="pb | pc | seg | w">
        <xsl:element name="cei:{local-name()}">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[name() != 'xml:id']"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="bibl | listBibl">
        <xsl:element name="cei:{local-name()}">
            <xsl:copy-of select="@*[name() != 'default']"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="bibl/note">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="gap">
        <cei:space>
            <xsl:apply-templates/>
        </cei:space>
    </xsl:template>

    <xsl:template match="soCalled">
        <cei:w>
            <xsl:attribute name="note">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </cei:w>
    </xsl:template>

    <xsl:template match="sic">
        <cei:sic>
            <xsl:if test="following-sibling::corr">
                <xsl:attribute name="corr">
                    <xsl:value-of select="following-sibling::corr"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend">
                <xsl:attribute name="rend">
                    <xsl:value-of select="@rend"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:sic>
    </xsl:template>

    <xsl:template match="corr"/>

    <xsl:template match="roleName">
        <cei:rolename>
            <xsl:apply-templates/>
        </cei:rolename>
    </xsl:template>

    <xsl:template match="name">
        <xsl:choose>
            <xsl:when test="parent::persName">
                <cei:forename>
                    <xsl:apply-templates/>
                </cei:forename>
            </xsl:when>
            <xsl:otherwise>
                <cei:persName>
                    <cei:forename>
                        <xsl:apply-templates/>
                    </cei:forename>
                </cei:persName>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="foreign">
        <cei:foreign>
            <xsl:attribute name="lang">
                <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
        </cei:foreign>
    </xsl:template>

    <xsl:template match="graphic">
        <cei:pict>
            <xsl:value-of select="@rend"/>
            <xsl:apply-templates/>
        </cei:pict>
    </xsl:template>

    <xsl:template match="num">
        <cei:num>
            <xsl:attribute name="value">99999999</xsl:attribute>
            <xsl:apply-templates/>
        </cei:num>
    </xsl:template>

    <xsl:template match="rdg">
        <cei:rdg>
            <xsl:copy-of select="@*[name() != 'ana']"/>
            <xsl:apply-templates/>
        </cei:rdg>
    </xsl:template>

    <xsl:template match="date">
        <cei:date>
            <xsl:attribute name="value">
                <xsl:value-of select="format-date(./@when, '[Y0001][M01][D01]')"/>
            </xsl:attribute>
            <xsl:value-of select="./text()"/>
        </cei:date>
    </xsl:template>

    <xsl:template match="div1/p//date">
        <cei:date value="99999999">
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>

    <xsl:template match="div1/p">
        <cei:pTenor>
            <xsl:apply-templates/>
        </cei:pTenor>
    </xsl:template>

    <xsl:template match="choice[expan and abbr]">
        <cei:expan>
            <xsl:attribute name="abbr">
                <xsl:value-of select="abbr"/>
            </xsl:attribute>
            <xsl:if test="./abbr/@rend">
                <xsl:attribute name="type">
                    <xsl:value-of select="./abbr/@rend"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="expan"/>
        </cei:expan>
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
        </cei:physicalDesc>
        <cei:auth>
            <cei:notariusDesc/>
            <cei:sealDesc/>
        </cei:auth>
        <cei:nota/>
        <cei:rubrum/>
    </xsl:template>

</xsl:stylesheet>
