<?xml version="1.0" encoding="UTF-8"?>

<!--Transformation von TEI-kodiertem Urkunden-Korpus zu CEI.-->

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
                        <cei:p>Créé sur MS Word, balisé sur oXgenXML. Version partielle contenant
                            les actes dont les originaux sont conservés.</cei:p>
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
                    <xsl:apply-templates select="teiHeader/profileDesc/abstract"/>
                    <xsl:apply-templates select="teiHeader/profileDesc/creation"/>
                    <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listWit"/>
                    <cei:diplomaticAnalysis>
                        <xsl:apply-templates select="teiHeader/fileDesc/sourceDesc/listBibl"/>
                        <cei:listBiblEdition>
                            <xsl:apply-templates
                                select="teiHeader/fileDesc/sourceDesc/listWit/witness/bibl"/>
                        </cei:listBiblEdition>
                    </cei:diplomaticAnalysis>
                </cei:chDesc>
                <cei:tenor>
                    <xsl:apply-templates select="text/body"/>
                </cei:tenor>
            </cei:body>
            <cei:back>
                <cei:divNotes>
                    <xsl:apply-templates
                        select="teiHeader/fileDesc/sourceDesc/listWit/witness/msDesc/physDesc/additions"
                    />
                </cei:divNotes>
                <cei:class/>
            </cei:back>
        </cei:text>
    </xsl:template>

    <xsl:template match="listWit">
        <cei:witnessOrig>
            <xsl:if
                test="contains(witness[@n = ('A', 'A1')]/msDesc/physDesc/objectDesc/supportDesc/support/p/text(), 'Original en parchemin')">
                <cei:traditioForm>Original</cei:traditioForm>
            </xsl:if>
            <xsl:apply-templates select="witness[@n = ('A', 'A1')]/node()[not(name() = 'bibl')]"/>
            <xsl:for-each select="./ancestor::TEI/facsimile/graphic[position() &lt; 3]">
                <cei:figure>
                    <xsl:apply-templates select="."/>
                </cei:figure>
            </xsl:for-each>
        </cei:witnessOrig>
        <xsl:if test="witness[not(@n = ('A', 'A1'))]">
            <cei:witListPar>
                <xsl:apply-templates select="head"/>
                <xsl:apply-templates select="witness[not(@n = ('A', 'A1'))]"/>
            </cei:witListPar>
        </xsl:if>
    </xsl:template>

    <xsl:template match="witness[not(@n = ('A', 'A1'))]">
        <cei:witness>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()[not(name() = 'bibl')]"/>
            <xsl:if test="@n = 'A2'">
                <xsl:for-each select="./ancestor::TEI/facsimile/graphic[position() &gt; 2]">
                    <cei:figure>
                        <xsl:apply-templates select="."/>
                    </cei:figure>
                </xsl:for-each>
            </xsl:if>
        </cei:witness>
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

    <xsl:template match="damage">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="damage[not(supplied)]">
        <cei:damage>
            <xsl:apply-templates/>
        </cei:damage>
    </xsl:template>

    <xsl:template match="supplied[parent::damage]">
        <cei:supplied>
            <xsl:copy-of select="@*"/>
            <cei:damage>
                <xsl:apply-templates select="../supplied/*"/>
            </cei:damage>
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

    <xsl:template match="graphic">
        <cei:graphic>
            <xsl:copy-of select="@url"/>
        </cei:graphic>
    </xsl:template>

    <xsl:template match="/teiCorpus/TEI[18]/text[1]/body[1]/p[1]/graphic[1]">
        <cei:pict>
            <xsl:attribute name="type">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:pict>
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
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:apply-templates/>
        </cei:w>
    </xsl:template>

    <xsl:template match="seg">
        <cei:seg>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:apply-templates/>
        </cei:seg>
    </xsl:template>

    <xsl:template match="pc">
        <cei:pc>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:apply-templates/>
        </cei:pc>
    </xsl:template>

    <xsl:template match="pb">
        <cei:pb>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:apply-templates/>
        </cei:pb>
    </xsl:template>

    <xsl:template match="bibl">
        <cei:bibl>
            <xsl:copy-of select="@*[not(name() = ('xml:id', 'sameAs', 'default'))]"/>
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
                    <xsl:copy-of select="@*[not(name() = 'default')]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </cei:listBibl>
    </xsl:template>

    <xsl:template match="date | origDate">
        <xsl:choose>
            <xsl:when test="@when castable as xs:date">
                <cei:date>
                    <xsl:attribute name="value">
                        <xsl:value-of select="format-date(@when, '[Y][M,2][D,2]')"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </cei:date>
            </xsl:when>
            <xsl:when test=".[@notBefore][@notAfter]">
                <cei:dateRange>
                    <xsl:attribute name="from">
                        <xsl:value-of
                            select="substring(concat(replace(@notBefore, '-', ''), '99999999'), 1, 4)"/>
                        <xsl:text>9999</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="to">
                        <xsl:value-of
                            select="substring(concat(replace(@notAfter, '-', ''), '99999999'), 1, 4)"/>
                        <xsl:text>9999</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </cei:dateRange>
            </xsl:when>
            <xsl:when test="@notBefore castable as xs:date">
                <cei:date>
                    <xsl:attribute name="value">
                        <xsl:value-of select="format-date(@notBefore, '[Y][M,2][D,2]')"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </cei:date>
            </xsl:when>
            <xsl:when test="matches(text()[normalize-space()][1], '^[\W]*(\d\d\d\d)[\W]*$')">
                <cei:date>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="concat(replace(text()[normalize-space()][1], '^[\W]*(\d\d\d\d)[\W]*$', '$1'), '9999')"
                        />
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </cei:date>
            </xsl:when>
            <!--TODO: Elegantere Behandlung für Monatsnamen einbauen-->
            <!--            <xsl:when test="matches(text()[normalize-space()][1], '^[\W]*(\d\d\d\d)[\W]* \d+ (\w+)$')">
                <xsl:attribute name="value">
                    <xsl:variable name="month" select=""/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:when>-->
            <xsl:when
                test="matches(text()[normalize-space()][1], '^[\W]*(\d\d\d\d)[-\s/]*(\d\d\d\d)[\W]*$')">
                <cei:dateRange>
                    <xsl:attribute name="from">
                        <xsl:value-of
                            select="concat(replace(text()[normalize-space()][1], '^[\W]*(\d\d\d\d)[-\s/]*(\d\d\d\d)[\W]*$', '$1'), '9999')"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="to">
                        <xsl:value-of
                            select="concat(replace(text()[normalize-space()][1], '^[\W]*(\d\d\d\d)[-\s/]*(\d\d\d\d)[\W]*$', '$2'), '9999')"
                        />
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </cei:dateRange>
            </xsl:when>
            <xsl:otherwise>
                <cei:date>
                    <xsl:attribute name="value">
                        <xsl:value-of
                            select="substring(concat(replace(@when, '-', ''), '99999999'), 1, 8)"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </cei:date>
            </xsl:otherwise>
        </xsl:choose>
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
        <cei:p type="layout">Columns: <xsl:value-of select="@columns"/>, Lines: <xsl:value-of
                select="@writtenLines"/> - <xsl:apply-templates select="normalize-space(.)"/>
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

    <xsl:template match="/teiCorpus/TEI[31]/text[1]/body[1]/p[1]/figure[1]">
        <cei:pict>
            <xsl:attribute name="type">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </cei:pict>
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
        <xsl:choose>
            <xsl:when test="parent::damage">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <cei:space>
                    <xsl:apply-templates/>
                </cei:space>
            </xsl:otherwise>
        </xsl:choose>
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
            <xsl:copy-of
                select="@*[not(name() = 'xml:space') and not((name() = 'rend' and contains(., 'background')))]"/>
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
            <xsl:copy-of select="@*[not(name() = ('place', 'corresp'))]"/>
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

    <!--<xsl:template match="ptr"/>-->
    <!--<xsl:template match="ref"/>-->

    <!--=====================-->
    <!-- manuelle Datumsangaben-->
    <!--=====================-->
    <xsl:template match="/teiCorpus/TEI[170]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11310101</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[171]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11251231</xsl:attribute>
            <xsl:attribute name="to">11360831</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[173]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11321231</xsl:attribute>
            <xsl:attribute name="to">11391231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[174]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11361231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[175]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11420901</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[176]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11421108</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[178]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11440430</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[179]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11450616</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[180]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11451231</xsl:attribute>
            <xsl:attribute name="to">11460603</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[183]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11480426</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[185]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11471231</xsl:attribute>
            <xsl:attribute name="to">11481231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[189]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11571220</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[190]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11621231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[191]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11541231</xsl:attribute>
            <xsl:attribute name="to">11621231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[192]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11541231</xsl:attribute>
            <xsl:attribute name="to">11621231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[193]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11541231</xsl:attribute>
            <xsl:attribute name="to">11621231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[194]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11640403</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[196]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11650415</xsl:attribute>
            <xsl:attribute name="to">11650416</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[197]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11691111</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[206]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11681231</xsl:attribute>
            <xsl:attribute name="to">11751018</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[210]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11821203</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[211]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11711231</xsl:attribute>
            <xsl:attribute name="to">11821231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[212]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11830308</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[214]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11841231</xsl:attribute>
            <xsl:attribute name="to">11850928</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[217]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11711231</xsl:attribute>
            <xsl:attribute name="to">11891231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[219]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11711231</xsl:attribute>
            <xsl:attribute name="to">11891231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[226]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11950423</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[227]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11951122</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[232]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11961031</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[246]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11981231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[257]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12040131</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[265]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12080312</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[266]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12080312</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[267]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12080314</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[272]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12090229</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[273]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12090630</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[274]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12090630</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[275]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12090630</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[276]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12090922</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[278]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12091231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[281]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12101210</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[286]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12110831</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[295]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12130229</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[296]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12131031</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[297]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12131231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[301]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">12081231</xsl:attribute>
            <xsl:attribute name="to">12131231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[302]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11651231</xsl:attribute>
            <xsl:attribute name="to">11951231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[312]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">11821004</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[313]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:dateRange>
            <xsl:attribute name="from">11711231</xsl:attribute>
            <xsl:attribute name="to">11861231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:dateRange>
    </xsl:template>
    <xsl:template match="/teiCorpus/TEI[317]/teiHeader[1]/profileDesc[1]/creation[1]/date[1]">
        <cei:date>
            <xsl:attribute name="value">12031231</xsl:attribute>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
</xsl:stylesheet>
