<?xml version="1.0" encoding="UTF-8"?>

<!--Transformation von TEI-kodiertem Urkunden-Korpus zu CEI.-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns:cei="http://www.monasterium.net/NS/cei" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <!--TEI als default namespace aus der Quelle übernehmen-->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="teiCorpus">
        <cei:cei>
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
                        <cei:p>Créé sur MS Word, balisé sur oXgenXML. Version partielle contenant les actes dont les originaux sont conservés.</cei:p>
                    </cei:sourceDesc>
                </cei:fileDesc>
            </cei:teiHeader>
            <cei:text>
                <cei:group>
                    <xsl:apply-templates select="TEI"/>
                </cei:group>
            </cei:text>
        </cei:cei>
    </xsl:template>

    <xsl:template match="sourceDesc">
        <cei:sourceDesc>
            <xsl:apply-templates/>
        </cei:sourceDesc>
    </xsl:template>

    <xsl:template match="TEI">
        <cei:text type="charter">
            <!--charter-type notwendig für MOMca-Import-->
            <cei:front>
                <cei:sourceDesc>
                    <cei:sourceDescVolltext>
                        <cei:bibl/>
                    </cei:sourceDescVolltext>
                    <cei:sourceDescRegest>
                        <cei:bibl/>
                    </cei:sourceDescRegest>
                </cei:sourceDesc>
                <xsl:apply-templates select="teiHeader/encodingDesc"/>
            </cei:front>
            <cei:body>
                <cei:idno>
                    <xsl:text>Fontenay-ID: </xsl:text>
                    <xsl:value-of select="count(preceding::TEI) + 1"/>
                    <!--automatische Nummerierung für jede Urkunde-->
                </cei:idno>
                <cei:chDesc>
                    <xsl:apply-templates select="facsimile"/>
                    <xsl:apply-templates select="teiHeader/profileDesc/abstract"/>
                    <xsl:apply-templates select="teiHeader/profileDesc/creation"/>
                    <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listWit"/>
                    <cei:diplomaticAnalysis>
                        <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listBibl"/>
                        <cei:listBiblEdition>
                            <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listWit/witness/bibl"/>
                        </cei:listBiblEdition>
                    </cei:diplomaticAnalysis>
                </cei:chDesc>
                <cei:tenor>
                    <xsl:apply-templates select="text/body"/>
                </cei:tenor>
            </cei:body>
            <cei:back>
                <cei:divNotes>
                    <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listWit/witness/msDesc/physDesc/additions"/>
                </cei:divNotes>
                <cei:class/>
            </cei:back>
        </cei:text>
    </xsl:template>

    <xsl:template match="listWit">
        <cei:witnessOrig>
            <cei:traditioForm>Original</cei:traditioForm>
            <xsl:apply-templates select="witness[@n = 'A']/node()[not(name() = 'bibl')]"/>
            <!--witness A ist der originale Textzeuge-->
        </cei:witnessOrig>
        <xsl:if test="witness[not(@n = 'A')]">
            <cei:witListPar>
                <xsl:apply-templates select="head"/>
                <xsl:apply-templates select="witness[not(@n = 'A')]"/>
            </cei:witListPar>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="bibl[parent::witnessOrig]"/>

    <xsl:template match="abstract">
        <cei:abstract>
            <xsl:apply-templates select="./p/node()"/>
        </cei:abstract>
    </xsl:template>

    <xsl:template match="additions">
        <cei:note>
            <xsl:attribute name="place">
                <xsl:value-of select="ancestor::witness/@n"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>

    <xsl:template match="title">
        <cei:title>
            <xsl:apply-templates/>
        </cei:title>
    </xsl:template>

    <xsl:template match="teiHeader">
        <cei:teiHeader>
            <xsl:apply-templates/>
        </cei:teiHeader>
    </xsl:template>

    <xsl:template match="settlement">
        <cei:settlement>
            <xsl:apply-templates/>
        </cei:settlement>
    </xsl:template>

    <xsl:template match="p">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>

    <xsl:template match="note">
        <cei:note>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>

    <xsl:template match="name">
        <cei:name>
            <xsl:apply-templates/>
        </cei:name>
    </xsl:template>

    <xsl:template match="surname">
        <cei:surname>
            <xsl:apply-templates/>
        </cei:surname>
    </xsl:template>

    <xsl:template match="orgName">
        <cei:orgName>
            <xsl:apply-templates/>
        </cei:orgName>
    </xsl:template>

    <xsl:template match="placeName">
        <cei:placeName>
            <xsl:apply-templates/>
        </cei:placeName>
    </xsl:template>

    <xsl:template match="geogName">
        <cei:geogName>
            <xsl:apply-templates/>
        </cei:geogName>
    </xsl:template>

    <xsl:template match="idno">
        <cei:idno>
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>

    <xsl:template match="height">
        <cei:height>
            <xsl:apply-templates/>
        </cei:height>
    </xsl:template>

    <xsl:template match="width">
        <cei:width>
            <xsl:apply-templates/>
        </cei:width>
    </xsl:template>

    <xsl:template match="handShift">
        <cei:handShift>
            <xsl:apply-templates/>
        </cei:handShift>
    </xsl:template>

    <xsl:template match="author">
        <cei:author>
            <xsl:apply-templates/>
        </cei:author>
    </xsl:template>

    <xsl:template match="supplied">
        <cei:supplied>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:supplied>
    </xsl:template>

    <xsl:template match="pc">
        <cei:pc>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:pc>
    </xsl:template>
    
    <xsl:template match="facsimile">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="graphic[parent::facsimile]">
        <cei:graphic>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="type">facsimile</xsl:attribute>
        </cei:graphic>
    </xsl:template>

    <xsl:template match="graphic">
        <cei:graphic>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:graphic>
    </xsl:template>

    <xsl:template match="del">
        <cei:del>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:del>
    </xsl:template>

    <xsl:template match="w">
        <cei:w>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[name() != 'xml:id']"/>
            <xsl:apply-templates/>
        </cei:w>
    </xsl:template>

    <xsl:template match="seg">
        <cei:seg>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[name() != 'xml:id']"/>
            <xsl:apply-templates/>
        </cei:seg>
    </xsl:template>

    <xsl:template match="pc">
        <cei:pc>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[name() != 'xml:id']"/>
            <xsl:apply-templates/>
        </cei:pc>
    </xsl:template>

    <xsl:template match="pb">
        <cei:pb>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[name() != 'xml:id']"/>
            <xsl:apply-templates/>
        </cei:pb>
    </xsl:template>

    <xsl:template match="bibl">
        <cei:bibl>
            <xsl:copy-of select="@*[name() != 'default' and name() != 'sameAs']"/>
            <xsl:if test="@sameAs">
                <xsl:attribute name="key">
                    <xsl:value-of select="@sameAs"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="n">
                <xsl:value-of select="parent::witness/@n"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:bibl>
    </xsl:template>

    <xsl:template match="listBibl">
        <cei:listBibl>
            <xsl:choose>
                <xsl:when test="@type = 'inventaires'">
                    <xsl:attribute name="n">inventaires</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="@*[name() != 'default']"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </cei:listBibl>
    </xsl:template>

    <!--making dates CEI-compliant: -->

    <xsl:template match="date | origDate">
        <cei:date>
            <xsl:choose>
                <xsl:when test="@when castable as xs:date">
                    <xsl:attribute name="value">
                        <xsl:value-of select="format-date(@when, '[Y][M,2][D,2]')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="matches(./string(), '^\d\d\d\d$')">
                    <xsl:attribute name="value">
                        <xsl:value-of select="concat(./string(), '9999')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="value">
                        <xsl:value-of select="99999999"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>

    <xsl:template match="(date | origDate)[matches(string()[normalize-space()], '^\d\d\d\d-\d\d\d\d$')]">
        <cei:dateRange>
            <xsl:attribute name="from">
                <xsl:value-of select="tokenize(text()[normalize-space()], '-')[1]"/>
                <xsl:text>9999</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="to">
                <xsl:value-of select="tokenize(text()[normalize-space()], '-')[2]"/>
                <xsl:text>9999</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>

    <xsl:template match="witness[@n != 'A']">
        <cei:witness>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*[not(name() = 'bibl')]"/>
        </cei:witness>
    </xsl:template>

    <xsl:template match="physDesc">
        <cei:physicalDesc>
            <xsl:apply-templates select="objectDesc/supportDesc"/>
        </cei:physicalDesc>
        <xsl:apply-templates select="handDesc"/>
        <xsl:apply-templates select="objectDesc/layoutDesc"/>
        <xsl:apply-templates select="scriptDesc"/>
    </xsl:template>

    <xsl:template match="supportDesc">
        <cei:material>
            <xsl:value-of select="support/@material"/>
            <xsl:value-of select="support/p"/>
        </cei:material>
        <cei:dimensions>
            <xsl:attribute name="type">
                <xsl:value-of select="extent/dimensions[1]/@type"/>
            </xsl:attribute>
            <xsl:attribute name="unit">
                <xsl:value-of select="extent/dimensions[1]/@unit"/>
            </xsl:attribute>
            <xsl:apply-templates select="extent/dimensions[1]"/>
        </cei:dimensions>
        <cei:dimensions>
            <xsl:attribute name="type">
                <xsl:value-of select="extent/dimensions[2]/@type"/>
            </xsl:attribute>
            <xsl:attribute name="unit">
                <xsl:value-of select="extent/dimensions[2]/@unit"/>
            </xsl:attribute>
            <xsl:apply-templates select="extent/dimensions[2]"/>
        </cei:dimensions>
    </xsl:template>

    <xsl:template match="layout">
        <cei:p type="layout">Columns: <xsl:value-of select="@columns"/>, Lines: <xsl:value-of select="@writtenLines"/> - <xsl:apply-templates select="normalize-space(.)"/>
        </cei:p>
    </xsl:template>

    <xsl:template match="history">
        <cei:p type="history">
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>

    <xsl:template match="figure">
        <cei:figure>
            <xsl:copy-of select="@*[not(name() = 'corresp' or name() = 'type')]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@type">
                <cei:figDesc>
                    <xsl:value-of select="@type"/>
                </cei:figDesc>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:figure>
    </xsl:template>

    <xsl:template match="desc[parent::figure]">
        <cei:figDesc>
            <xsl:apply-templates/>
        </cei:figDesc>
    </xsl:template>

    <xsl:template match="handDesc">
        <cei:p type="handDesc">
            <xsl:apply-templates select="normalize-space(.)"/>
        </cei:p>
    </xsl:template>

    <xsl:template match="scriptDesc">
        <cei:p type="scriptDesc">
            <xsl:apply-templates select="normalize-space(.)"/>
        </cei:p>
    </xsl:template>

    <xsl:template match="msIdentifier">
        <cei:archIdentifier>
            <xsl:apply-templates/>
        </cei:archIdentifier>
    </xsl:template>

    <xsl:template match="repository">
        <cei:arch>
            <xsl:apply-templates/>
        </cei:arch>
    </xsl:template>

    <xsl:template match="choice[expan and abbr]">
        <xsl:choose>
            <xsl:when test="abbr/*">
                <!--diese Kondition holt Kind-Elemente aus abbr (z.B., hi, sic) und plaziert sie ausserhalb der cei:expan-->
                <xsl:choose>
                    <xsl:when test="abbr/*[name() = 'g']">
                        <cei:c>
                            <xsl:copy-of select="abbr/*/@*"/>
                            <xsl:apply-templates select="expan"/>
                        </cei:c>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="cei:{abbr/*/local-name()}">
                            <xsl:copy-of select="abbr/*/@*"/>
                            <xsl:apply-templates select="expan"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="expan"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="expan">
        <cei:expan>
            <xsl:attribute name="abbr">
                <xsl:value-of select="normalize-space(following-sibling::abbr)"/>
            </xsl:attribute>
            <xsl:if test="following-sibling::abbr/@rend">
                <xsl:attribute name="type">
                    <xsl:value-of select="following-sibling::abbr/@rend"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:expan>
    </xsl:template>

    <xsl:template match="supplied[parent::damage]">
        <xsl:element name="cei:{local-name()}">
            <xsl:copy-of select="@*"/>
            <cei:damage>
                <xsl:apply-templates/>
            </cei:damage>
        </xsl:element>
    </xsl:template>

    <xsl:template match="w[parent::soCalled]">
        <cei:w>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="note">soCalled</xsl:attribute>
            <xsl:apply-templates/>
        </cei:w>
    </xsl:template>

    <xsl:template match="locus">
        <cei:scope>
            <xsl:apply-templates/>
        </cei:scope>
    </xsl:template>

    <xsl:template match="sic">
        <cei:sic>
            <xsl:if test="following-sibling::corr">
                <xsl:attribute name="corr">
                    <xsl:value-of select="following-sibling::corr"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@*[not(name() = 'corresp')]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:sic>
    </xsl:template>

    <xsl:template match="corr"/>
    <!--corr-Daten sind in <sic> untergebracht-->

    <xsl:template match="persName">
        <cei:persName>
            <xsl:attribute name="key">
                <xsl:text>FontenayPersons:</xsl:text>
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:persName>
    </xsl:template>

    <xsl:template match="name">
        <cei:name>
            <xsl:apply-templates/>
        </cei:name>
    </xsl:template>

    <xsl:template match="roleName">
        <cei:rolename>
            <xsl:apply-templates/>
        </cei:rolename>
    </xsl:template>

    <xsl:template match="addName">
        <cei:addName>
            <xsl:apply-templates/>
        </cei:addName>
    </xsl:template>

    <xsl:template match="surname">
        <cei:surname>
            <xsl:apply-templates/>
        </cei:surname>
    </xsl:template>

    <xsl:template match="foreign">
        <cei:foreign>
            <xsl:attribute name="lang">
                <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:foreign>
    </xsl:template>

    <xsl:template match="gap">
        <cei:space>
            <xsl:apply-templates/>
        </cei:space>
    </xsl:template>

    <xsl:template match="num">
        <cei:num>
            <xsl:attribute name="value">99999999</xsl:attribute>
            <!--Platzhalter, da num in der CEI ein @value-Attribut braucht-->
            <xsl:apply-templates/>
        </cei:num>
    </xsl:template>

    <xsl:template match="app">
        <cei:app>
            <xsl:copy-of select="@*"/>
            <xsl:if test="not(lem)">
                <cei:lem/>
            </xsl:if>
            <xsl:apply-templates select="lem"/>
            <xsl:if test="not(rdg)">
                <cei:rdg/>
            </xsl:if>
            <xsl:apply-templates select="rdg"/>
            <xsl:apply-templates select="*[not(name() = 'lem') and not(name() = 'rdg')]"/>
        </cei:app>
    </xsl:template>

    <xsl:template match="rdg">
        <cei:rdg>
            <xsl:if test="@rend">
                <xsl:attribute name="type">
                    <xsl:value-of select="@rend"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@*[name() = 'wit']"/>
            <xsl:apply-templates/>
        </cei:rdg>
    </xsl:template>

    <xsl:template match="lem">
        <cei:lem>
            <xsl:copy-of select="@*[not(name() = 'type')]"/>
            <xsl:apply-templates/>
        </cei:lem>
    </xsl:template>

    <xsl:template match="q | quote">
        <cei:quote>
            <xsl:apply-templates/>
        </cei:quote>
    </xsl:template>

    <xsl:template match="hi">
        <xsl:element name="cei:{local-name()}">
            <xsl:copy-of select="@*[name() != 'xml:space' and not((name() = 'rend' and contains(., 'background')))]"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="g">
        <cei:c>
            <xsl:apply-templates/>
        </cei:c>
    </xsl:template>

    <xsl:template match="creation">
        <cei:issued>
            <xsl:apply-templates select="*[not(name() = 'hi' and @rend)]"/>
        </cei:issued>
    </xsl:template>

    <xsl:template match="biblScope">
        <cei:scope>
            <xsl:apply-templates/>
        </cei:scope>
    </xsl:template>

    <xsl:template match="add">
        <cei:add>
            <xsl:copy-of select="@*[name() != 'place' and name() != 'corresp']"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@place">
                <xsl:attribute name="type">
                    <xsl:value-of select="@place"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:add>
    </xsl:template>

    <xsl:template match="p[parent::origin or parent::history]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p[parent::div/parent::body or parent::body]">
        <cei:pTenor>
            <xsl:apply-templates/>
        </cei:pTenor>
    </xsl:template>

    <xsl:template match="geogFeat">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="lb">
        <cei:lb>
            <xsl:copy-of select="@*[not(name() = 'corresp')]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:lb>
    </xsl:template>

    <xsl:template match="space">
        <cei:space>
            <xsl:copy-of select="@*[not(name() = 'corresp')]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:space>
    </xsl:template>

    <xsl:template match="witDetail">
        <cei:witDetail>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:witDetail>
    </xsl:template>

    <xsl:template match="witStart">
        <cei:witStart>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:witStart>
    </xsl:template>

    <xsl:template match="witEnd">
        <cei:witEnd>
            <xsl:apply-templates/>
        </cei:witEnd>
    </xsl:template>

    <xsl:template match="lacunaStart">
        <cei:lacunaStart>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:lacunaStart>
    </xsl:template>

    <xsl:template match="lacunaEnd">
        <cei:lacunaEnd>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:lacunaEnd>
    </xsl:template>

    <xsl:template match="term">
        <cei:term>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:term>
    </xsl:template>

    <xsl:template match="surplus">
        <cei:surplus>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:surplus>
    </xsl:template>

    <xsl:template match="metamark">
        <cei:metamark>
            <xsl:apply-templates/>
        </cei:metamark>
    </xsl:template>

    <xsl:template match="unclear">
        <cei:unclear>
            <xsl:apply-templates/>
        </cei:unclear>
    </xsl:template>

    <xsl:template match="note[parent::adminInfo]">
        <cei:note>
            <xsl:attribute name="type">adminInfo</xsl:attribute>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>

    <xsl:template match="head">
        <cei:head>
            <xsl:apply-templates/>
        </cei:head>
    </xsl:template>

    <xsl:template match="desc">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="encodingDesc">
        <cei:encodingDesc>
            <xsl:apply-templates/>
        </cei:encodingDesc>
    </xsl:template>

    <xsl:template match="damage">
        <cei:damage>
            <xsl:apply-templates/>
        </cei:damage>
    </xsl:template>

    <!--<xsl:template match="ptr"/>-->
    <!--<xsl:template match="ref"/>-->
</xsl:stylesheet>
