<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:cei="http://www.monasterium.net/NS/cei">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!--<xsl:template match="/">
        <ceiCorpus>
            <xsl:apply-templates/>
        </ceiCorpus>
    </xsl:template>-->

    <xsl:template match="/">
        <!--später auf TEI ändern und Korpus zu Root machen-->
        <cei:text>
            <cei:front>
                <xsl:apply-templates select="TEI/teiHeader"/>
            </cei:front>
            <cei:body>
                <cei:idno>[PLATZHALTER]</cei:idno>
                <cei:chDesc>
                    <cei:abstract>
                        <xsl:apply-templates select="TEI/teiHeader/profileDesc/abstract"/>
                    </cei:abstract>
                    <cei:issued>
                        <xsl:apply-templates select="/TEI/teiHeader/profileDesc/creation"/>
                    </cei:issued>
                    <cei:witList>
                        <xsl:apply-templates select="/TEI/teiHeader/fileDesc/sourceDesc/listWit"/>
                    </cei:witList>
                    <cei:diplomaticAnalysis>
                        <cei:listBibl>
                            <xsl:apply-templates select="//listBibl"/>
                        </cei:listBibl>
                    </cei:diplomaticAnalysis>
                    <cei:lang_MOM/>
                </cei:chDesc>
            </cei:body>
        </cei:text>
    </xsl:template>

    <xsl:template match="fileDesc">
        <cei:sourceDesc>[PLATZHALTER]</cei:sourceDesc>
    </xsl:template>

    <xsl:template match="date">
        <cei:date>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>

    <xsl:template match="note">
        <cei:note>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>

    <xsl:template match="listBibl">
        <cei:listBibl>
            <xsl:apply-templates/>
        </cei:listBibl>
    </xsl:template>

    <xsl:template match="bibl">
        <cei:bibl>
            <xsl:apply-templates/>
        </cei:bibl>
    </xsl:template>

    <xsl:template match="titleStmt">
        <cei:titleStmt>
            <xsl:apply-templates/>
        </cei:titleStmt>
    </xsl:template>

    <xsl:template match="title">
        <cei:title>
            <xsl:apply-templates/>
        </cei:title>
    </xsl:template>

    <xsl:template match="author">
        <cei:author>
            <xsl:apply-templates/>
        </cei:author>
    </xsl:template>

    <xsl:template match="persName">
        <cei:persName>
            <xsl:apply-templates/>
        </cei:persName>
    </xsl:template>

    <xsl:template match="lb">
        <cei:lb>
            <xsl:apply-templates/>
        </cei:lb>
    </xsl:template>

    <xsl:template match="p">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>

    <xsl:template match="witness">
        <cei:witness>
            <cei:traditioForm/>
            <cei:figure/>
            <cei:archIdentifier>
                <xsl:apply-templates select="//msIdentifier"/>
            </cei:archIdentifier>
            <cei:physicalDesc>
                <xsl:apply-templates select="//physDesc"/>
                <cei:material>
                    <xsl:apply-templates select="//support"/>
                </cei:material>
                <cei:dimensions>
                    <xsl:apply-templates select="//dimensions"/>
                </cei:dimensions>
                <cei:condition/>
            </cei:physicalDesc>
            <cei:auth>
                <cei:sealDesc/>
                <cei:notariusDesc/>
            </cei:auth>
            <cei:nota/>
            <cei:rubrum/>
        </cei:witness>
    </xsl:template>

    <xsl:template match="settlement">
        <cei:settlement>
            <xsl:apply-templates/>
        </cei:settlement>
    </xsl:template>

    <xsl:template match="repository">
        <cei:arch>
            <xsl:apply-templates/>
        </cei:arch>
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

</xsl:stylesheet>
