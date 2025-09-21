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
                    <!-- default to Reading view; JS can flip -->
                    <body class="mode-reading">
                        <header>
                            <div class="topbar">
                                <nav>
                                    <a href="calendar.html">Diary (Calendar)</a>
                                    <a href="../facsimiles/">Facsimiles</a>
                                    <a href="../persons/">Persons</a>
                                    <a href="../works/">Works</a>
                                    <a href="../places/">Places</a>
                                    <a href="../organizations/">Organizations</a>
                                    <a href="../about/">About</a>
                                </nav>
                                <button id="toggle-view" class="toggle">Switch to
                                    Diplomatic</button>
                            </div>
                            <h1>
                                <xsl:value-of select="tei:head/tei:date"/>
                            </h1>
                        </header>

                        <main class="diary-text">
                            <!-- Render paragraphs etc. -->
                            <xsl:apply-templates select="node()"/>
                        </main>

                        <!-- Notes side panel (populated here per entry) -->
                        <div id="notes-panel">
                            <div
                                style="display:flex;justify-content:space-between;align-items:center">
                                <h2>Notes</h2>
                                <button data-close-notes="" class="toggle">Close</button>
                            </div>
                            <div class="notes-content">
                                <!-- Author notes -->
                                <xsl:for-each select=".//tei:note[@place = 'left']">
                                    <div class="note author" data-note="{generate-id()}">
                                        <small>Note by Schönberg</small>
                                        <div>
                                            <xsl:apply-templates/>
                                        </div>
                                    </div>
                                </xsl:for-each>
                                <!-- Editor notes -->
                                <xsl:for-each select=".//tei:note[@type = 'comment']">
                                    <div class="note editor" data-note="{generate-id()}">
                                        <small>Editor's note</small>
                                        <div>
                                            <xsl:apply-templates/>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>

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
                <body class="mode-reading">
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                            </nav>
                            <button id="toggle-view" class="toggle">Switch to Diplomatic</button>
                        </div>
                        <h1>Diary — Calendar (stub)</h1>
                    </header>
                    <main>
                        <p>This is a placeholder. In the next step we'll render a full
                            month-by-month calendar.</p>
                        <ul>
                            <xsl:for-each select="//tei:div[@type = 'entry']">
                                <li>
                                    <a
                                        href="{concat(normalize-space(tei:head/tei:date/@when),'.html')}">
                                        <xsl:value-of select="tei:head/tei:date"/>
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
    </xsl:template>

    <!-- ============ RENDERING TEMPLATES FOR ENTRY CONTENT ============ -->

    <!-- Pass through text nodes -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Paragraphs -->
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

    <!-- Deletions / Overwritten -->
    <xsl:template match="tei:del">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <!-- Additions -->
    <xsl:template match="tei:add">
        <span class="add" data-place="{@place}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Persons / Works / Places / Orgs -->
    <xsl:template match="tei:persName">
        <span class="person" data-ref="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:title[@type = 'music']">
        <span class="work" data-ref="{@ref}">🎵 <xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <span class="place" data-ref="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <span class="org" data-ref="{@ref}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Page breaks with facsimile link -->
    <xsl:template match="tei:pb">
        <div class="pb">
            <strong>Page <xsl:value-of select="@n"/></strong>
            <xsl:text> — </xsl:text>
            <a href="{@facs}" target="_blank">📄 Open facsimile</a>
        </div>
    </xsl:template>

    <!-- Notes: insert small clickable icons inline; the full note bodies live in the side panel -->
    <xsl:template match="tei:note[@place = 'left']">
        <span class="note-icon author" title="Note by Schönberg" data-note-id="{generate-id()}"
            >🖊️</span>
    </xsl:template>

    <xsl:template match="tei:note[@type = 'comment']">
        <span class="note-icon editor" title="Editor's note" data-note-id="{generate-id()}"
            >ℹ️</span>
    </xsl:template>

    <!-- Head / date inside the entry (we already render as H1 in header) – skip local output -->
    <xsl:template match="tei:head"/>
    <xsl:template match="tei:head/tei:date"/>

</xsl:stylesheet>
