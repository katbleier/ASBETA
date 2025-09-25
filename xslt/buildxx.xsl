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
                                    <a href="../index.html">Home</a>
                                    <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                    <a href="../diary/all.html">Tagebuch gesamt</a>
                                    <a href="../persons/index.html">Personen</a>
                                    <a href="../works/index.html">Werke</a>
                                    <a href="../places/index.html">Orte</a>
                                    <a href="../organizations/index.html">Organisationen</a>
                                    <a href="../about.html">Über diese Edition</a>
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

        <!-- List of Entries -->
        <xsl:result-document href="diary/calendar.html" method="xhtml" indent="yes">
            <html lang="en">
                <head>
                    <meta charset="utf-8"/>
                    <title>Tagebuch Einträge</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                                <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                <a href="../diary/all.html">Tagebuch gesamt</a>
                                <a href="../persons/index.html">Personen</a>
                                <a href="../works/index.html">Werke</a>
                                <a href="../places/index.html">Orte</a>
                                <a href="../organizations/index.html">Organisationen</a>
                                <a href="../about.html">Über diese Edition</a>
                            </nav>
                        </div>
                        <h1>Tagebuch Einträge</h1>
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
                    <title>Tagebuch gesamt</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body class="mode-diplomatic">
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                                <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                <a href="../diary/all.html">Tagebuch gesamt</a>
                                <a href="../persons/index.html">Personen</a>
                                <a href="../works/index.html">Werke</a>
                                <a href="../places/index.html">Orte</a>
                                <a href="../organizations/index.html">Organisationen</a>
                                <a href="../about.html">Über diese Edition</a>
                            </nav>
                            <button id="toggle-view" class="toggle">Switch to Reading</button>
                        </div>
                        <h1>Tagebuch gesamt</h1>
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
                    <title>Index — Personen</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                                <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                <a href="../diary/all.html">Tagebuch gesamt</a>
                                <a href="../persons/index.html">Personen</a>
                                <a href="../works/index.html">Werke</a>
                                <a href="../places/index.html">Orte</a>
                                <a href="../organizations/index.html">Organisationen</a>
                                <a href="../about.html">Über diese Edition</a>
                            </nav>
                        </div>
                        <h1>Personen Index</h1>
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
                                    <small>
                                        <!-- Get unique diary entries where person is mentioned -->
                                        <xsl:variable name="mentionedEntries" 
                                            select="//tei:persName[@ref = concat('#', current()/@xml:id)]/ancestor::tei:div[@type = 'entry']"/>
                                        
                                        <xsl:if test="$mentionedEntries">
                                            <xsl:text>Mentions in: </xsl:text>
                                            <xsl:for-each select="$mentionedEntries">
                                                <xsl:sort select="@n" data-type="number"/>
                                                <!-- Remove duplicates by checking if this entry hasn't been processed before -->
                                                <xsl:if test="not(preceding::tei:div[@type = 'entry'][@n = current()/@n])">
                                                    <a href="../diary/entry-{@n}.html">
                                                        <xsl:value-of select="tei:head/tei:date"/>
                                                    </a>
                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
                                        
                                        <!-- Mentions as author of works -->
                                        <xsl:variable name="authoredWorks" 
                                            select="//tei:listBibl/tei:bibl[tei:author/tei:persName/@ref = concat('#', current()/@xml:id)]"/>
                                        
                                        <xsl:if test="$authoredWorks">
                                            <xsl:if test="$mentionedEntries">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                            <xsl:for-each select="$authoredWorks">
                                                <xsl:text>(as author: </xsl:text>
                                                <a href="../works/index.html#{@xml:id}">
                                                    <xsl:value-of select="tei:title"/>
                                                </a>
                                                <xsl:text>)</xsl:text>
                                                <xsl:if test="position() != last()">, </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
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
                    <title>Index — Organisationen</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                                <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                <a href="../diary/all.html">Tagebuch gesamt</a>
                                <a href="../persons/index.html">Personen</a>
                                <a href="../works/index.html">Werke</a>
                                <a href="../places/index.html">Orte</a>
                                <a href="../organizations/index.html">Organisationen</a>
                                <a href="../about.html">Über diese Edition</a>
                            </nav>
                        </div>
                        <h1>Organisationen Index</h1>
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
                                    <small>
                                        <xsl:variable name="mentionedEntries" 
                                            select="//tei:orgName[@ref = concat('#', current()/@xml:id)]/ancestor::tei:div[@type = 'entry']"/>
                                        
                                        <xsl:if test="$mentionedEntries">
                                            <xsl:text>Mentions in: </xsl:text>
                                            <xsl:for-each select="$mentionedEntries">
                                                <xsl:sort select="@n" data-type="number"/>
                                                <xsl:if test="not(preceding::tei:div[@type = 'entry'][@n = current()/@n])">
                                                    <a href="../diary/entry-{@n}.html">
                                                        <xsl:value-of select="tei:head/tei:date"/>
                                                    </a>
                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
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
                    <title>Index — Orte</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                                <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                <a href="../diary/all.html">Tagebuch gesamt</a>
                                <a href="../persons/index.html">Personen</a>
                                <a href="../works/index.html">Werke</a>
                                <a href="../places/index.html">Orte</a>
                                <a href="../organizations/index.html">Organisationen</a>
                                <a href="../about.html">Über diese Edition</a>
                            </nav>
                        </div>
                        <h1>Orte Index</h1>
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
                                    <small>
                                        <xsl:variable name="mentionedEntries" 
                                            select="//tei:placeName[@ref = concat('#', current()/@xml:id)]/ancestor::tei:div[@type = 'entry']"/>
                                        
                                        <xsl:if test="$mentionedEntries">
                                            <xsl:text>Mentions in: </xsl:text>
                                            <xsl:for-each select="$mentionedEntries">
                                                <xsl:sort select="@n" data-type="number"/>
                                                <xsl:if test="not(preceding::tei:div[@type = 'entry'][@n = current()/@n])">
                                                    <a href="../diary/entry-{@n}.html">
                                                        <xsl:value-of select="tei:head/tei:date"/>
                                                    </a>
                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
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
                    <title>Index — Werke</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="../index.html">Home</a>
                                <a href="../diary/calendar.html">Tagebuch Einträge</a>
                                <a href="../diary/all.html">Tagebuch gesamt</a>
                                <a href="../persons/index.html">Personen</a>
                                <a href="../works/index.html">Werke</a>
                                <a href="../places/index.html">Orte</a>
                                <a href="../organizations/index.html">Organisationen</a>
                                <a href="../about.html">Über diese Edition</a>
                            </nav>
                        </div>
                        <h1>Werke Index</h1>
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
                                    <small>
                                        <xsl:variable name="mentionedEntries" 
                                            select="//tei:title[@type = 'music'][@ref = concat('#', current()/@xml:id)]/ancestor::tei:div[@type = 'entry']"/>
                                        
                                        <xsl:if test="$mentionedEntries">
                                            <xsl:text>Mentions in: </xsl:text>
                                            <xsl:for-each select="$mentionedEntries">
                                                <xsl:sort select="@n" data-type="number"/>
                                                <xsl:if test="not(preceding::tei:div[@type = 'entry'][@n = current()/@n])">
                                                    <a href="../diary/entry-{@n}.html">
                                                        <xsl:value-of select="tei:head/tei:date"/>
                                                    </a>
                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:if>
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
         <!-- ================= ABOUT PAGE ================= -->
        <xsl:result-document href="about.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Über diese Edition</title>
                    <link rel="stylesheet" href="css/style.css"/>
                </head>
                <body>
                    <header>
                        <div class="topbar">
                            <nav>
                                <a href="index.html">Home</a>
                                <a href="diary/calendar.html">Tagebuch Einträge</a>
                                <a href="diary/all.html">Tagebuch gesamt</a>
                                <a href="persons/index.html">Personen</a>
                                <a href="works/index.html">Werke</a>
                                <a href="places/index.html">Orte</a>
                                <a href="organizations/index.html">Organisationen</a>
                                <a href="about.html">Über diese Edition</a>
                            </nav>
                        </div>
                        <h1>Über diese Edition</h1>
                    </header>
                    <main>
                        <section class="metadata">
                            <h2>Source Document</h2>
                            <dl>
                                <dt>Title:</dt>
                                <dd><xsl:value-of select="//tei:titleStmt/tei:title[@type='source']"/></dd>
                                
                                <dt>Uniform Title:</dt>
                                <dd><xsl:value-of select="//tei:titleStmt/tei:title[@type='uniform']"/></dd>
                                
                                <dt>Author:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:titleStmt/tei:author/tei:forename"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="//tei:titleStmt/tei:author/tei:surname"/>
                                    <xsl:if test="//tei:titleStmt/tei:author/@ref">
                                        <xsl:text> — </xsl:text>
                                        <a href="{//tei:titleStmt/tei:author/@ref}" target="_blank">GND</a>
                                    </xsl:if>
                                </dd>
                                
                                <dt>Editor:</dt>
                                <dd>
                                    <xsl:value-of select="//tei:titleStmt/tei:editor/tei:forename"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="//tei:titleStmt/tei:editor/tei:surname"/>
                                    <xsl:if test="//tei:titleStmt/tei:editor/@ref">
                                        <xsl:text> — </xsl:text>
                                        <a href="{//tei:titleStmt/tei:editor/@ref}" target="_blank">GND</a>
                                    </xsl:if>
                                </dd>
                            </dl>
                        </section>
                        
                        <section class="manuscript">
                            <h2>Manuscript Information</h2>
                            <dl>
                                <dt>Repository:</dt>
                                <dd><xsl:value-of select="//tei:msIdentifier/tei:institution"/></dd>
                                
                                <dt>Location:</dt>
                                <dd><xsl:value-of select="//tei:msIdentifier/tei:settlement/tei:placeName"/></dd>
                                
                                <dt>Collection:</dt>
                                <dd><xsl:value-of select="//tei:msIdentifier/tei:collection"/></dd>
                                
                                <dt>Shelf Mark:</dt>
                                <dd><xsl:value-of select="//tei:msIdentifier/tei:idno[@type='shelfmark']"/></dd>
                                
                                <xsl:if test="//tei:msIdentifier/tei:altIdentifier/tei:idno[@type='URI']">
                                    <dt>Digital Resource:</dt>
                                    <dd>
                                        <a href="{//tei:msIdentifier/tei:altIdentifier/tei:idno[@type='URI']}" 
                                            target="_blank">View in Repository</a>
                                    </dd>
                                </xsl:if>
                            </dl>
                        </section>
                        
                        <section class="publication">
                            <h2>Publication Information</h2>
                            <dl>
                                <dt>Publisher:</dt>
                                <dd><xsl:value-of select="//tei:publicationStmt/tei:publisher/tei:persName"/></dd>
                                
                                <dt>Publication Date:</dt>
                                <dd><xsl:value-of select="//tei:publicationStmt/tei:date"/></dd>
                                
                                <dt>Publication Place:</dt>
                                <dd><xsl:value-of select="//tei:publicationStmt/tei:pubPlace"/></dd>
                                
                                <dt>License:</dt>
                                <dd>
                                    <a href="{//tei:publicationStmt/tei:availability/tei:licence/@target}" 
                                        target="_blank">
                                        <xsl:value-of select="//tei:publicationStmt/tei:availability/tei:licence"/>
                                    </a>
                                </dd>
                            </dl>
                        </section>
                        
                        <section class="statistics">
                            <h2>Edition Statistics</h2>
                            <dl>
                                <dt>Diary Entries:</dt>
                                <dd><xsl:value-of select="count(//tei:div[@type='entry'])"/></dd>
                                
                                <dt>Persons Referenced:</dt>
                                <dd><xsl:value-of select="count(//tei:listPerson/tei:person)"/></dd>
                                
                                <dt>Places Referenced:</dt>
                                <dd><xsl:value-of select="count(//tei:listPlace/tei:place)"/></dd>
                                
                                <dt>Musical Works:</dt>
                                <dd><xsl:value-of select="count(//tei:listBibl/tei:bibl)"/></dd>
                                
                                <dt>Organizations:</dt>
                                <dd><xsl:value-of select="count(//tei:listOrg/tei:org)"/></dd>
                            </dl>
                        </section>
                        
                        <section class="technical">
                            <h2>Technical Information</h2>
                            <p>This digital edition was created using:</p>
                            <ul>
                                <li><strong>TEI P5</strong> for text encoding</li>
                                <li><strong>XSLT 3.0</strong> for HTML transformation</li>
                                <li><strong>CSS3</strong> for styling and responsive design</li>
                                <li><strong>JavaScript</strong> for interactive features</li>
                            </ul>
                            
                            <p>The edition offers two viewing modes:</p>
                            <ul>
                                <li><strong>Diplomatic mode</strong>: Shows all editorial apparatus including deletions, additions, and manuscript features</li>
                                <li><strong>Reading mode</strong>: Provides a clean reading text with additions integrated and deletions hidden</li>
                            </ul>
                        </section>
                    </main>
                    
                    <script src="js/toggle.js"/>
                    <script src="js/notes.js"/>
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
                <a href="../persons/index.html#{$id}" class="person">
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
                <a href="../works/index.html#{$id}" class="work">
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
                <a href="../places/index.html#{$id}" class="place">
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
                <a href="../organizations/index.html#{$id}" class="org">
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
            <strong>Seite <xsl:value-of select="@n"/></strong>
            <xsl:text> — </xsl:text>
            <a href="{@facs}" target="_blank">Faksimile</a>
        </div>
    </xsl:template>


    <!-- Notes: insert small clickable icons inline; the full note bodies live in the side panel -->
    <xsl:template match="tei:note[@place]">
        <span class="note author" data-place="{@place}">
            <button class="note-toggle note-author">✎</button>
            <span class="popup-author">
                Anmerkung Schönberg, 
                    <xsl:choose>
                        <xsl:when test="@place = 'left'">linker</xsl:when>
                        <xsl:when test="@place = 'right'">rechter</xsl:when>
                        <xsl:when test="@place = 'top'">oberer</xsl:when>
                        <xsl:when test="@place = 'bottom'">unterer</xsl:when>
                        <xsl:otherwise><xsl:value-of select="@place"/></xsl:otherwise>
                    </xsl:choose>
                    Rand: 
                <xsl:apply-templates select="node()"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template match="tei:note[@type = 'commentary']">
        <span class="note commentary">
            <button class="note-toggle">‡</button>
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
            <span class="popup-add">
                <xsl:choose>
                    <xsl:when test="@place = 'above'">über der Zeile</xsl:when>
                    <xsl:when test="@place = 'below'">unterhalb der Zeile</xsl:when>
                    <xsl:when test="@place = 'inline'">innerhalb der Zeile</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@place"/></xsl:otherwise>
                </xsl:choose>
                hinzugefügt</span>
        </span>
    </xsl:template>

    <!-- Deletions / Overwritten -->
    <xsl:template match="tei:del">
        <span class="textcrit del" data-rend="{@rend}">
            <span class="del-text">
                <xsl:apply-templates/>
            </span>
            <span class="popup-del">Gelöscht (
                <xsl:choose>
                    <xsl:when test="@rend = 'strikethrough'">durchgestrichen</xsl:when>
                    <xsl:when test="@rend = 'overwritten'">überschrieben</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@rend"/></xsl:otherwise>
                </xsl:choose>
                )</span>
        </span>
    </xsl:template>

    <!-- Head / date inside the entry (we already render as H1 in header) – skip local output -->
    <xsl:template match="tei:head">
        <span class="entry-head-inline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


</xsl:stylesheet>
