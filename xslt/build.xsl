<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs">

    <xsl:output method="xhtml" indent="yes"/>

    <!-- Entry point -->
    <xsl:template match="/">
        <!-- Generate one HTML file per diary entry -->
        <xsl:for-each select="//tei:text/tei:body/tei:div[@type = 'entry']">
            <xsl:variable name="id" as="xs:string" select="@n"/>
            <xsl:result-document href="{concat('diary/entry-',$id,'.html')}" method="xhtml"
                indent="yes">
                <html lang="de">
                    <head>
                        <meta charset="utf-8"/>
                        <title>
                            <xsl:text>Berliner Tagebuch — </xsl:text>
                            <xsl:value-of select="tei:head/tei:date"/>
                        </title>
                        <link rel="stylesheet" href="../css/style.css"/>
                    </head>
                    <!-- default to Diplomatic view; JS can flip -->
                    <body class="mode-diplomatic">
                        <header>
                            <div class="topbar">
                                <nav>
                                    <a href="../diary/calendar.html">Diary</a>
                                    <a href="../diary/all.html">All Entries</a>
                                    <a href="../facsimiles/index.html">Facsimiles</a>
                                    <a href="../persons/index.html">Persons</a>
                                    <a href="../works/index.html">Works</a>
                                    <a href="../places/index.html">Places</a>
                                    <a href="../organizations/index.html">Organizations</a>
                                    <a href="../about.html">About</a>
                                </nav>
                                <button id="toggle-view" class="toggle">Switch to Reading</button>
                            </div>
                            <h1>
                                <xsl:value-of select="concat(@n, '. Tagebucheintrag, ')"/>
                                <xsl:value-of
                                    select="format-date(tei:head/tei:date/@when, '[D01].[M01].[Y0001]')"
                                />
                            </h1>
                        </header>

                        <main class="diary-text">
                            <!-- Render paragraphs etc. -->
                            <xsl:apply-templates select="node()"/>
                        </main>

                        <script src="../js/toggle.js"/>
                        <script src="../js/notes.js"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Stub calendar page; we'll build it properly in the next step -->
        <xsl:result-document href="diary/calendar.html" method="xhtml" indent="yes">
            <html lang="en">
                <head>
                    <meta charset="utf-8"/>
                    <title>Diary — Calendar</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                        </div>
                        <h1>Diary — Entries</h1>
                    </header>
                    <main>
                        <ul>
                            <xsl:for-each select="//tei:div[@type = 'entry']">
                                <li>
                                    <a href="{concat('entry-',@n,'.html')}">
                                        <xsl:value-of
                                            select="format-date((.//tei:date/@when)[1], '[D01].[M01].[Y0001]')"
                                        />
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </main>

                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>

        <!-- ================= ALL ENTRIES PAGE ================= -->
        <xsl:result-document href="diary/all.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Berliner Tagebuch – Gesamtausgabe (Scroll)</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body class="mode-diplomatic">
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                            <button id="toggle-view" class="toggle">Switch to Reading</button>
                        </div>
                        <h1>Gesamtausgabe (Scrollansicht)</h1>
                    </header>

                    <main class="diary-scroll">
                        <!-- Alles linear ausgeben -->
                        <xsl:apply-templates select="//tei:text/tei:body/node()"/>
                    </main>

                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>

        <!-- ================= PERSONS INDEX ================= -->
        <xsl:result-document href="persons/index.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Index — Persons</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                        </div>
                        <h1>Persons Index</h1>
                    </header>
                    <main>
                        <ul>
                            <xsl:for-each select="//tei:listPerson/tei:person">
                                <xsl:sort select="tei:persName"/>
                                <li id="{@xml:id}">
                                    <!-- Person's name -->
                                    <strong>
                                        <xsl:value-of select="tei:persName"/>
                                    </strong>

                                    <!-- GND link if present -->
                                    <xsl:if test="tei:idno[@type = 'gnd']">
                                        <xsl:text> — </xsl:text>
                                        <a href="https://d-nb.info/gnd/{tei:idno[@type='gnd']}"
                                            target="_blank">GND</a>
                                    </xsl:if>

                                    <!-- Mentions in entries -->
                                    <br/>
                                    <small>Mentions in: <xsl:for-each
                                            select="//tei:persName[@ref = concat('#', current()/@xml:id)]">
                                            <xsl:variable name="entry"
                                                select="ancestor::tei:div[@type = 'entry']"/>
                                            <xsl:variable name="entryId" select="$entry/@n"/>
                                            <a href="../diary/entry-{$entryId}.html">
                                                <xsl:value-of select="$entry/tei:head/tei:date"/>
                                            </a>
                                            <xsl:if test="position() != last()">, </xsl:if>
                                        </xsl:for-each>
                                    </small>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </main>
                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>
        <!-- ================= ORGANIZATIONS INDEX ================= -->
        <xsl:result-document href="organizations/index.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Index — Organizations</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                        </div>
                        <h1>Organizations Index</h1>
                    </header>
                    <main>
                        <ul>
                            <xsl:for-each select="//tei:listOrg/tei:org">
                                <xsl:sort select="tei:orgName"/>
                                <li id="{@xml:id}">
                                    <!-- Org name -->
                                    <strong>
                                        <xsl:value-of select="tei:orgName"/>
                                    </strong>

                                    <!-- GND link -->
                                    <xsl:if test="tei:idno[@type = 'gnd']">
                                        <xsl:text> — </xsl:text>
                                        <a href="https://d-nb.info/gnd/{tei:idno[@type='gnd']}"
                                            target="_blank">GND</a>
                                    </xsl:if>

                                    <!-- Mentions -->
                                    <br/>
                                    <small>Mentions in: <xsl:for-each
                                            select="//tei:orgName[@ref = concat('#', current()/@xml:id)]">
                                            <xsl:variable name="entry"
                                                select="ancestor::tei:div[@type = 'entry']"/>
                                            <xsl:variable name="entryId" select="$entry/@n"/>
                                            <a href="../diary/entry-{$entryId}.html">
                                                <xsl:value-of select="$entry/tei:head/tei:date"/>
                                            </a>
                                            <xsl:if test="position() != last()">, </xsl:if>
                                        </xsl:for-each>
                                    </small>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </main>
                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>
        <!-- ================= PLACES INDEX ================= -->
        <xsl:result-document href="places/index.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Index — Places</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                        </div>
                        <h1>Places Index</h1>
                    </header>
                    <main>
                        <ul>
                            <xsl:for-each select="//tei:listPlace/tei:place">
                                <xsl:sort select="tei:placeName"/>
                                <li id="{@xml:id}">
                                    <!-- Place name -->
                                    <strong>
                                        <xsl:value-of select="tei:placeName"/>
                                    </strong>

                                    <!-- GND link -->
                                    <xsl:if test="tei:placeName/@ref">
                                        <xsl:text> — </xsl:text>
                                        <a href="{tei:placeName/@ref}" target="_blank">GND</a>
                                    </xsl:if>

                                    <!-- Coordinates -->
                                    <xsl:if test="tei:location/tei:geo">
                                        <xsl:text> — </xsl:text>
                                        <a
                                            href="https://www.openstreetmap.org/?mlat={substring-before(tei:location/tei:geo,' ')}&amp;mlon={substring-after(tei:location/tei:geo,' ')}&amp;zoom=12"
                                            target="_blank">Map</a>
                                    </xsl:if>

                                    <!-- Mentions -->
                                    <br/>
                                    <small>Mentions in: <xsl:for-each
                                            select="//tei:placeName[@ref = concat('#', current()/@xml:id)]">
                                            <xsl:variable name="entry"
                                                select="ancestor::tei:div[@type = 'entry']"/>
                                            <xsl:variable name="entryId" select="$entry/@n"/>
                                            <a href="../diary/entry-{$entryId}.html">
                                                <xsl:value-of select="$entry/tei:head/tei:date"/>
                                            </a>
                                            <xsl:if test="position() != last()">, </xsl:if>
                                        </xsl:for-each>
                                    </small>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </main>
                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>
        <!-- ================= WORKS INDEX ================= -->
        <xsl:result-document href="works/index.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Index — Works</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                        </div>
                        <h1>Works Index</h1>
                    </header>
                    <main>
                        <ul>
                            <xsl:for-each select="//tei:listBibl/tei:bibl">
                                <xsl:sort select="tei:author/tei:persName"/>
                                <li id="{@xml:id}">
                                    <!-- Author first -->
                                    <strong>
                                        <xsl:value-of select="tei:author/tei:persName"/>
                                    </strong>
                                    <xsl:text>: </xsl:text>
                                    <xsl:value-of select="tei:title"/>

                                    <!-- GND link for work -->
                                    <xsl:if test="tei:title/@ref">
                                        <xsl:text> — </xsl:text>
                                        <a href="{tei:title/@ref}" target="_blank">GND</a>
                                    </xsl:if>

                                    <!-- Mentions in diary -->
                                    <br/>
                                    <small>Mentions in: <xsl:for-each
                                            select="//tei:title[@type = 'music'][@ref = concat('#', current()/@xml:id)]">
                                            <xsl:variable name="entry"
                                                select="ancestor::tei:div[@type = 'entry']"/>
                                            <xsl:variable name="entryId" select="$entry/@n"/>
                                            <a href="../diary/entry-{$entryId}.html">
                                                <xsl:value-of select="$entry/tei:head/tei:date"/>
                                            </a>
                                            <xsl:if test="position() != last()">, </xsl:if>
                                        </xsl:for-each>
                                    </small>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </main>
                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>
        <!-- ================= FACSIMILES INDEX ================= -->
        <xsl:result-document href="facsimiles/index.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Facsimiles Overview</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                    <style>
                        .thumbs {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 1rem;
                        }
                        .thumbs a {
                            display: block;
                            text-align: center;
                            font-size: 0.8em;
                        }
                        .thumbs img {
                            max-width: 150px;
                            border: 1px solid #ccc;
                        }</style>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../diary/calendar.html">Diary</a>
                                <a href="../diary/all.html">All Entries</a>
                                <a href="../facsimiles/index.html">Facsimiles</a>
                                <a href="../persons/index.html">Persons</a>
                                <a href="../works/index.html">Works</a>
                                <a href="../places/index.html">Places</a>
                                <a href="../organizations/index.html">Organizations</a>
                                <a href="../about.html">About</a>
                            </nav>
                        </div>
                        <h1>Facsimiles Overview</h1>
                    </header>
                    <main>
                        <xsl:for-each-group select="//tei:pb[@facs]"
                            group-by="ancestor::tei:div[@type = 'entry']/@n">
                            <xsl:variable name="entryId" select="current-grouping-key()"/>
                            <xsl:variable name="entry"
                                select="current-group()[1]/ancestor::tei:div[@type = 'entry']"/>
                            <section>
                                <h2> Entry <xsl:value-of select="$entryId"/> — <xsl:value-of
                                        select="$entry/tei:head/tei:date"/>
                                </h2>
                                <div class="thumbs">
                                    <xsl:for-each select="current-group()">
                                        <a href="{@facs}" target="_blank">
                                            <img src="{@facs}" alt="Facsimile page {@n}"/>
                                            <br/>Page <xsl:value-of select="@n"/>
                                        </a>
                                    </xsl:for-each>
                                </div>
                            </section>
                        </xsl:for-each-group>
                    </main>
                    <script src="../js/toggle.js"/>
                    <script src="../js/notes.js"/>
                </body>
            </html>
        </xsl:result-document>


    </xsl:template>

    <!-- ============ RENDERING TEMPLATES FOR ENTRY CONTENT ============ -->

    <!-- Pass through text nodes -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Paragraphs that should continue inline (no linebreak) -->
    <xsl:template match="tei:p[@rend = 'inline']">
        <span class="inline-paragraph">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Normal paragraphs -->
    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <!-- Inline emphasis -->
    <xsl:template match="tei:hi[@rend = 'underline']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>


    <!-- render external links -->
    <xsl:template match="tei:ref">
        <a href="{@target}" target="_blank">
            <xsl:apply-templates/>
        </a>
    </xsl:template>


    <!-- Persons / Works / Places / Orgs -->
    <xsl:template match="tei:persName">
        <xsl:variable name="ref" select="@ref"/>
        <xsl:choose>
            <!-- Internal reference (e.g. #p1) -->
            <xsl:when test="starts-with($ref, '#')">
                <xsl:variable name="id" select="substring($ref, 2)"/>
                <xsl:variable name="target"
                    select="//tei:listPerson/tei:person[@xml:id = $id]/tei:persName"/>
                <a href="../persons/index.html#{$id}" class="person" title="{$target}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <!-- External reference (e.g. GND link) -->
            <xsl:otherwise>
                <a href="{$ref}" class="person" target="_blank">
                    <xsl:value-of select="."/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:title[@type = 'music']">
        <xsl:variable name="ref" select="@ref"/>
        <xsl:choose>
            <!-- Internal reference -->
            <xsl:when test="starts-with($ref, '#')">
                <xsl:variable name="id" select="substring($ref, 2)"/>
                <xsl:variable name="target"
                    select="//tei:listBibl/tei:bibl[@xml:id = $id]/tei:title"/>
                <a href="../works/index.html#{$id}" class="work" title="{$target}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <!-- External reference -->
            <xsl:otherwise>
                <a href="{$ref}" class="work" target="_blank">
                    <xsl:value-of select="."/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <xsl:variable name="ref" select="@ref"/>
        <xsl:choose>
            <!-- Internal reference -->
            <xsl:when test="starts-with($ref, '#')">
                <xsl:variable name="id" select="substring($ref, 2)"/>
                <xsl:variable name="target"
                    select="//tei:listPlace/tei:place[@xml:id = $id]/tei:placeName"/>
                <a href="../places/index.html#{$id}" class="place" title="{$target}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <!-- External reference -->
            <xsl:otherwise>
                <a href="{$ref}" class="place" target="_blank">
                    <xsl:value-of select="."/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <xsl:variable name="ref" select="@ref"/>
        <xsl:choose>
            <!-- Internal reference -->
            <xsl:when test="starts-with($ref, '#')">
                <xsl:variable name="id" select="substring($ref, 2)"/>
                <xsl:variable name="target"
                    select="//tei:listOrg/tei:org[@xml:id = $id]/tei:orgName"/>
                <a href="../organizations/index.html#{$id}" class="org" title="{$target}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <!-- External reference -->
            <xsl:otherwise>
                <a href="{$ref}" class="org" target="_blank">
                    <xsl:value-of select="."/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Page breaks with facsimile link -->
    <xsl:template match="tei:pb">
        <hr class="page-break"/>
        <div class="pb">
            <strong>Page <xsl:value-of select="@n"/></strong>
            <xsl:text> — </xsl:text>
            <a href="{@facs}" target="_blank">📄 Open facsimile</a>
        </div>
    </xsl:template>


    <!-- Notes: insert small clickable icons inline; the full note bodies live in the side panel -->
    <xsl:template match="tei:note[@place]">
        <span class="note author" data-place="{@place}">
            <button class="note-toggle note-author">✎</button>
            <span class="popup-author">
                <small>Note by Schönberg, <xsl:value-of select="@place"/> margin: </small>
                <xsl:apply-templates select="node()"/>
            </span>
        </span>
    </xsl:template>



    <xsl:template match="tei:note[@type = 'commentary']">
        <span class="note commentary">
            <button class="note-toggle">ℹ</button>
            <span class="popup-commentary">
                <xsl:apply-templates/>
            </span>
        </span>
    </xsl:template>

    <!-- Additions -->
    <xsl:template match="tei:add">
        <span class="textcrit add" data-place="{@place}">
            <span class="add-text">
                <xsl:apply-templates/>
            </span>
            <span class="popup-add"> Added (<xsl:value-of select="@place"/>) </span>
        </span>
    </xsl:template>

    <!-- Deletions / Overwritten -->
    <xsl:template match="tei:del">
        <span class="textcrit del" data-rend="{@rend}">
            <span class="del-text">
                <xsl:apply-templates/>
            </span>
            <span class="popup-del"> Deleted (<xsl:value-of select="@rend"/>) </span>
        </span>
    </xsl:template>

    <!-- Head / date inside the entry (we already render as H1 in header) – skip local output -->
    <xsl:template match="tei:head">
        <span class="entry-head-inline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>



</xsl:stylesheet>
