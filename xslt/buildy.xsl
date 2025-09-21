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
                        
                        <script src="../js/toggle.js"></script>
                        <script src="../js/notes.js"></script>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
        
        <!-- ================= CALENDAR PAGE ================= -->
        <xsl:result-document href="diary/calendar.html" method="xhtml" indent="yes">
            <html lang="de">
                <head>
                    <meta charset="utf-8"/>
                    <title>Diary — Calendar</title>
                    <link rel="stylesheet" href="../css/style.css"/>
                    <style>
                        table.calendar { border-collapse: collapse; margin:1rem 0; }
                        table.calendar th, table.calendar td { border:1px solid #ccc; width:2.5em; height:2.5em; text-align:center; }
                        table.calendar th { background:#f5f5f5; }
                        table.calendar td.empty { background:#fafafa; }
                        table.calendar td a { display:block; text-decoration:none; color:#06c; font-weight:bold; }
                    </style>
                </head>
                <body class="mode-reading">
                    <header>
                        <div class="topbar">
                            <nav><a href="../index.html">Home</a></nav>
                            <button id="toggle-view" class="toggle">Switch to Diplomatic</button>
                        </div>
                        <h1>Diary — Calendar</h1>
                    </header>
                    <main>
                        <xsl:for-each-group select="//tei:div[@type='entry'][tei:head/tei:date/@when]" 
                            group-by="substring(tei:head/tei:date/@when,1,7)">
                            <xsl:sort select="current-grouping-key()"/>
                            <xsl:variable name="yearMonth" select="current-grouping-key()"/>
                            <xsl:variable name="year" select="substring($yearMonth,1,4)"/>
                            <xsl:variable name="month" select="substring($yearMonth,6,2)"/>
                            
                            <h2><xsl:value-of select="$year"/>-<xsl:value-of select="$month"/></h2>
                            <table class="calendar">
                                <tr>
                                    <th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th><th>Su</th>
                                </tr>
                                
                                <!-- Compute first day of the month using correct day-of-week calculation -->
                                <xsl:variable name="firstDayOfWeek" as="xs:integer">
                                    <xsl:variable name="dayOfWeek" select="format-date(xs:date(concat($yearMonth,'-01')), '[F1]')" as="xs:string"/>
                                    <xsl:choose>
                                        <xsl:when test="$dayOfWeek = 'Monday'">1</xsl:when>
                                        <xsl:when test="$dayOfWeek = 'Tuesday'">2</xsl:when>
                                        <xsl:when test="$dayOfWeek = 'Wednesday'">3</xsl:when>
                                        <xsl:when test="$dayOfWeek = 'Thursday'">4</xsl:when>
                                        <xsl:when test="$dayOfWeek = 'Friday'">5</xsl:when>
                                        <xsl:when test="$dayOfWeek = 'Saturday'">6</xsl:when>
                                        <xsl:when test="$dayOfWeek = 'Sunday'">7</xsl:when>
                                        <xsl:otherwise>1</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="daysInMonth" as="xs:integer"
                                    select="day-from-date(xs:date(concat($yearMonth,'-01')) + xs:yearMonthDuration('P1M') - xs:dayTimeDuration('P1D'))"/>
                                
                                <xsl:variable name="totalCells" as="xs:integer" select="$daysInMonth + $firstDayOfWeek - 1"/>
                                <xsl:variable name="totalRows" as="xs:integer" select="ceiling($totalCells div 7)"/>
                                
                                <!-- Generate calendar rows -->
                                <xsl:for-each select="1 to $totalRows">
                                    <xsl:variable name="rowNum" select="." as="xs:integer"/>
                                    <tr>
                                        <xsl:for-each select="1 to 7">
                                            <xsl:variable name="cellNum" select="(($rowNum - 1) * 7) + ." as="xs:integer"/>
                                            <xsl:variable name="day" select="$cellNum - $firstDayOfWeek + 1" as="xs:integer"/>
                                            
                                            <xsl:choose>
                                                <xsl:when test="$day &lt;= 0 or $day &gt; $daysInMonth">
                                                    <td class="empty"></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:variable name="dateISO" 
                                                        select="concat($yearMonth,'-',format-number($day,'00'))"/>
                                                    <xsl:variable name="entry" 
                                                        select="current-group()[tei:head/tei:date/@when=$dateISO]"/>
                                                    
                                                    <td>
                                                        <xsl:choose>
                                                            <xsl:when test="$entry">
                                                                <a href="{concat('entry-',$entry/@n,'.html')}">
                                                                    <xsl:value-of select="$day"/>
                                                                </a>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$day"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </xsl:for-each-group>
                    </main>
                    <script src="../js/toggle.js"></script>
                    <script src="../js/notes.js"></script>
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