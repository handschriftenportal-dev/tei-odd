<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">

    <xsl:template name="decodeSpecialCharacters1UC">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
            replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
            replace(replace(replace(replace(replace(
            $value,
            '\\uc2\\u176 \\\^81\\\^8b\\uc1 ', '&#176;'),
            '\\uc2°\\\^8b\\uc1 ', '°'),
            '\\uc2→\\\^fa\\uc1 ', '→'),
            '\\uc2×\\\^c1\\uc1 ', '×'),
            '\\uc2·E\\uc1 ', '·'),
            '\\uc2·P\\uc1 ', '·'),
            '\\u-1808 \\~', ' '),
            '\\u-3856 \?', '&#x21E8;'),
            '\\u-4051 \?', '&lt;lb/&gt;&lt;lb/&gt;&#2012;'),
            '\\u-4052 \?', ''),
            '\\u-4085 \?', '&#x0304;'),
            '\\u-6355 \?', 'u&#x0366;'),
            '\\u-6357 \?', 'u&#x0364;'),
            '\\u-6588 \?', 'o&#x0364;'),
            '\\u-6692 \?', 'n&#x0304;'),
            '\\u-7106 \?', '&#x1F9E;'),
            '\\u-7114 \?', '&#x1F0E;'),
            '\\u-7124 \?', 'a&#x0364;'),
            '\\u-7312 \?', '&#x038F;'),
            '\\u-7368 \?', '&#58167;'),
            '\\u-7383 \?', '&#x0305;'),
            '\\u-7396 \?', '&#x0374;'),
            '\\u8226 \\bullet', '&#8226;'),
            '\\u8309 5', '&#8309;'),
            '\\uc2\\u183 \\\^a1P\\uc1 ', '&#183;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U16">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u16')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u161', '&#161;'), '\\u162', '&#162;'), '\\u163', '&#163;'), '\\u166', '&#166;'), '\\u167', '&#167;'), '\\u168', '&#168;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U17">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u17')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u170', '&#170;'), '\\u171', '&#171;'), '\\u172', '&#172;'), '\\u174', '&#174;'), '\\u175', '&#175;'), '\\u176', '&#176;'), '\\u177', '&#177;'), '\\u178', '&#178;'), '\\u179', '&#179;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U18">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u18')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u180', '&#180;'), '\\u181', '&#181;'), '\\u182', '&#182;'), '\\u183', '&#183;'), '\\u184', '&#184;'), '\\u185', '&#185;'), '\\u186', '&#186;'), '\\u187', '&#187;'), '\\u188', '&#188;'), '\\u189', '&#189;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U19">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u19')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u190', '&#190;'), '\\u191', '&#191;'), '\\u192', '&#192;'), '\\u193', '&#193;'), '\\u194', '&#194;'), '\\u195', '&#195;'), '\\u196', '&#196;'), '\\u197', '&#197;'), '\\u198', '&#198;'), '\\u199', '&#199;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U1">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u1')">
                <xsl:variable name="convertSpecialCharacters1U16">
                    <xsl:call-template name="decodeSpecialCharacters1U16">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U17">
                    <xsl:call-template name="decodeSpecialCharacters1U17">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U16"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U18">
                    <xsl:call-template name="decodeSpecialCharacters1U18">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U17"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U19">
                    <xsl:call-template name="decodeSpecialCharacters1U19">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U18"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U19"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U20">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u20')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u200', '&#200;'), '\\u201', '&#201;'), '\\u202', '&#202;'), '\\u203', '&#203;'), '\\u204', '&#204;'), '\\u205', '&#205;'), '\\u206', '&#206;'), '\\u207', '&#207;'), '\\u208', '&#208;'), '\\u209', '&#209;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U21">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u21')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u210', '&#210;'), '\\u211', '&#211;'), '\\u212', '&#212;'), '\\u213', '&#213;'), '\\u214', '&#214;'), '\\u215', '&#215;'), '\\u216', '&#216;'), '\\u217', '&#217;'), '\\u218', '&#218;'), '\\u219', '&#219;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U22">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u22')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u220', '&#220;'), '\\u221', '&#221;'), '\\u222', '&#222;'), '\\u223', '&#223;'), '\\u224', '&#224;'), '\\u225', '&#225;'), '\\u226', '&#226;'), '\\u227', '&#227;'), '\\u228', '&#228;'), '\\u229', '&#229;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U23">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u23')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u230', '&#230;'), '\\u231', '&#231;'), '\\u232', '&#232;'), '\\u233', '&#233;'), '\\u234', '&#234;'), '\\u235', '&#235;'), '\\u236', '&#236;'), '\\u237', '&#237;'), '\\u238', '&#238;'), '\\u239', '&#239;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U24">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u24')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u240', '&#240;'), '\\u241', '&#241;'), '\\u242', '&#242;'), '\\u243', '&#243;'), '\\u244', '&#244;'), '\\u245', '&#245;'), '\\u246', '&#246;'), '\\u247', '&#247;'), '\\u248', '&#248;'), '\\u249', '&#249;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U25">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u25')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u250', '&#250;'), '\\u251', '&#251;'), '\\u252', '&#252;'), '\\u253', '&#253;'), '\\u254', '&#254;'), '\\u255', '&#255;'), '\\u256', '&#256;'), '\\u257', '&#257;'), '\\u259', '&#259;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U26">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u26')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u261', '&#261;'), '\\u262', '&#262;'), '\\u263', '&#263;'), '\\u267', '&#267;'), '\\u268', '&#268;'), '\\u269', '&#269;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U27">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u27')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u271', '&#271;'), '\\u273', '&#273;'), '\\u275', '&#275;'), '\\u277', '&#277;'), '\\u278', '&#278;'), '\\u279', '&#279;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U28">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u28')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u280', '&#280;'), '\\u281', '&#281;'), '\\u283', '&#283;'), '\\u286', '&#286;'), '\\u287', '&#287;'), '\\u288', '&#288;'), '\\u289', '&#289;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U29">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u29')) then
                replace(replace(replace(replace(
                $value,
                '\\u295', '&#295;'), '\\u297', '&#297;'), '\\u298', '&#298;'), '\\u299', '&#299;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U2">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u2')">
                <xsl:variable name="convertSpecialCharacters1U20">
                    <xsl:call-template name="decodeSpecialCharacters1U20">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U21">
                    <xsl:call-template name="decodeSpecialCharacters1U21">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U20"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U22">
                    <xsl:call-template name="decodeSpecialCharacters1U22">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U21"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U23">
                    <xsl:call-template name="decodeSpecialCharacters1U23">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U22"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U24">
                    <xsl:call-template name="decodeSpecialCharacters1U24">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U23"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U25">
                    <xsl:call-template name="decodeSpecialCharacters1U25">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U24"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U26">
                    <xsl:call-template name="decodeSpecialCharacters1U26">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U25"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U27">
                    <xsl:call-template name="decodeSpecialCharacters1U27">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U26"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U28">
                    <xsl:call-template name="decodeSpecialCharacters1U28">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U27"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U29">
                    <xsl:call-template name="decodeSpecialCharacters1U29">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U28"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters1U29"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U30">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u30')) then
                replace(replace(replace(replace(
                $value,
                '\\u301', '&#301;'), '\\u304', '&#304;'), '\\u305', '&#305;'), '\\u307', '&#307;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U32">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u32')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u321', '&#321;'), '\\u322', '&#322;'), '\\u323', '&#323;'), '\\u324', '&#324;'), '\\u326', '&#326;'), '\\u328', '&#328;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U33">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u33')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u332', '&#332;'), '\\u333', '&#333;'), '\\u334', '&#334;'), '\\u335', '&#335;'), '\\u337', '&#337;'), '\\u338', '&#338;'), '\\u339', '&#339;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U34">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u34')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u341', '&#341;'), '\\u344', '&#344;'), '\\u345', '&#345;'), '\\u346', '&#346;'), '\\u347', '&#347;'), '\\u348', '&#348;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U35">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u35')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u350', '&#350;'), '\\u351', '&#351;'), '\\u352', '&#352;'), '\\u353', '&#353;'), '\\u355', '&#355;'), '\\u357', '&#357;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U36">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u36')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u361', '&#361;'), '\\u362', '&#362;'), '\\u363', '&#363;'), '\\u365', '&#365;'), '\\u366', '&#366;'), '\\u367', '&#367;'), '\\u369', '&#369;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U37">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u37')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u375', '&#375;'), '\\u376', '&#376;'), '\\u377', '&#377;'), '\\u378', '&#378;'), '\\u379', '&#379;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U38">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u38')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u380', '&#380;'), '\\u381', '&#381;'), '\\u382', '&#382;'), '\\u383', '&#383;'), '\\u384', '&#384;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U39">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u39')) then
                replace(
                $value,
                '\\u390', '&#390;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U3">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u3')">
                <xsl:variable name="convertSpecialCharacters1U30">
                    <xsl:call-template name="decodeSpecialCharacters1U30">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U32">
                    <xsl:call-template name="decodeSpecialCharacters1U32">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U30"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U33">
                    <xsl:call-template name="decodeSpecialCharacters1U33">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U32"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U34">
                    <xsl:call-template name="decodeSpecialCharacters1U34">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U33"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U35">
                    <xsl:call-template name="decodeSpecialCharacters1U35">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U34"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U36">
                    <xsl:call-template name="decodeSpecialCharacters1U36">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U35"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U37">
                    <xsl:call-template name="decodeSpecialCharacters1U37">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U36"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U38">
                    <xsl:call-template name="decodeSpecialCharacters1U38">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U37"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U39">
                    <xsl:call-template name="decodeSpecialCharacters1U39">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U38"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters1U39"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U40">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u40')) then
            replace(
            $value,
            '\\u407', '&#407;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U41">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u41')) then
            replace(
            $value,
            '\\u410', '&#410;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U42">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u42')) then
            replace(replace(
            $value,
            '\\u423', '&#423;'), '\\u428', '&#428;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U43">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u43')) then
                replace(replace(
                $value,
                '\\u438', '&#438;'), '\\u439', '&#439;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U44">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u44')) then
                replace(replace(
                $value,
                '\\u448', '&#448;'), '\\u449', '&#449;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U46">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u46')) then
                replace(replace(replace(
                $value,
                '\\u465', '&#465;'), '\\u466', '&#466;'), '\\u468', '&#468;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U48">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u48')) then
                replace(replace(
                $value,
                '\\u486', '&#486;'), '\\u487', '&#487;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U4">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u4')">
                <xsl:variable name="convertSpecialCharacters1U40">
                    <xsl:call-template name="decodeSpecialCharacters1U40">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U41">
                    <xsl:call-template name="decodeSpecialCharacters1U41">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U40"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U42">
                    <xsl:call-template name="decodeSpecialCharacters1U42">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U41"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U43">
                    <xsl:call-template name="decodeSpecialCharacters1U43">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U42"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U44">
                    <xsl:call-template name="decodeSpecialCharacters1U44">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U43"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U46">
                    <xsl:call-template name="decodeSpecialCharacters1U46">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U44"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U48">
                    <xsl:call-template name="decodeSpecialCharacters1U48">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U46"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U48"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U5">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u5')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u515', '&#515;'), '\\u519', '&#519;'),
                '\\u531', '&#531;'),
                '\\u541', '&#541;'),
                '\\u553', '&#553;'),
                '\\u576', '&#576;'),
                '\\u593', '&#593;'),
                '\\u596', '&#596;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U60">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u60')) then
            replace(replace(
            $value,
            '\\u601', '&#601;'), '\\u603', '&#603;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U61">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u61')) then
            replace(replace(
            $value,
            '\\u618', '&#618;'), '\\u619', '&#619;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U62">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u62')) then
            replace(
            $value,
            '\\u628', '&#628;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U64">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u64')) then
                replace(
                $value,
                '\\u643', '&#643;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U65">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u65')) then
            replace(replace(
            $value,
            '\\u657', '&#657;'), '\\u658', '&#658;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U66">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u66')) then
            replace(
            $value,
            '\\u664', '&#664;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U68">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u68')) then
            replace(
            $value,
            '\\u688', '&#688;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U69">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u69')) then
                replace(replace(
                $value,
                '\\u697', '&#697;'), '\\u699', '&#699;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U6">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u6')">
                <xsl:variable name="convertSpecialCharacters1U60">
                    <xsl:call-template name="decodeSpecialCharacters1U60">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U61">
                    <xsl:call-template name="decodeSpecialCharacters1U61">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U60"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U62">
                    <xsl:call-template name="decodeSpecialCharacters1U62">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U61"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U64">
                    <xsl:call-template name="decodeSpecialCharacters1U64">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U62"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U65">
                    <xsl:call-template name="decodeSpecialCharacters1U65">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U64"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U66">
                    <xsl:call-template name="decodeSpecialCharacters1U66">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U65"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U68">
                    <xsl:call-template name="decodeSpecialCharacters1U68">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U66"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U69">
                    <xsl:call-template name="decodeSpecialCharacters1U69">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U68"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters1U69"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U70">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u70')) then
                replace(replace(replace(replace(
                $value,
                '\\u700', '&#700;'), '\\u701', '&#701;'), '\\u702', '&#702;'), '\\u703', '&#703;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U71">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u71')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u711', '&#711;'), '\\u712', '&#712;'), '\\u713', '&#713;'), '\\u714', '&#714;'), '\\u719', '&#719;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U72">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u72')) then
            replace(
            $value,
            '\\u729', '&#729;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U73">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u73')) then
            replace(
            $value,
            '\\u730', '&#730;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U75">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u75')) then
                replace(
                $value,
                '\\u750', '&#750;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U76">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u76')) then
                replace(replace(
                $value,
                '\\u768', '&#768;'), '\\u769', '&#769;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U77">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u77')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u770', '&#770;'), '\\u771', '&#771;'), '\\u772', '&#772;'), '\\u773', '&#773;'), '\\u774', '&#774;'), '\\u775', '&#775;'), '\\u776', '&#776;'), '\\u778', '&#778;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U78">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u78')) then
            replace(replace(replace(replace(replace(
            $value,
            '\\u780', '&#780;'), '\\u781', '&#781;'), '\\u785', '&#785;'), '\\u787', '&#787;'), '\\u789', '&#789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U79">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u79')) then
            replace(
            $value,
            '\\u796', '&#796;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U7">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u7')">
                <xsl:variable name="convertSpecialCharacters1U70">
                    <xsl:call-template name="decodeSpecialCharacters1U70">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U71">
                    <xsl:call-template name="decodeSpecialCharacters1U71">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U70"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U72">
                    <xsl:call-template name="decodeSpecialCharacters1U72">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U71"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U73">
                    <xsl:call-template name="decodeSpecialCharacters1U73">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U72"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U75">
                    <xsl:call-template name="decodeSpecialCharacters1U75">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U73"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U76">
                    <xsl:call-template name="decodeSpecialCharacters1U76">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U75"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U77">
                    <xsl:call-template name="decodeSpecialCharacters1U77">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U76"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U78">
                    <xsl:call-template name="decodeSpecialCharacters1U78">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U77"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U79">
                    <xsl:call-template name="decodeSpecialCharacters1U79">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U78"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters1U79"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U80">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u80')) then
                replace(replace(replace(
                $value,
                '\\u803', '&#803;'), '\\u807', '&#807;'), '\\u808', '&#808;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U82">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u82')) then
                replace(replace(replace(
                $value,
                '\\u822', '&#822;'), '\\u823', '&#823;'), '\\u824', '&#824;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U83">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u83')) then
            replace(replace(replace(
            $value,
            '\\u834', '&#834;'), '\\u836', '&#836;'), '\\u837', '&#837;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U84">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u84')) then
            replace(
            $value,
            '\\u847', '&#847;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U85">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u85')) then
                replace(
                $value,
                '\\u855', '&#855;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U86">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u86')) then
                replace(replace(replace(replace(
                $value,
                '\\u862', '&#862;'), '\\u864', '&#864;'), '\\u867', '&#867;'), '\\u868', '&#868;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U87">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u87')) then
                replace(replace(replace(replace(
                $value,
                '\\u870', '&#870;'), '\\u871', '&#871;'), '\\u878', '&#878;'), '\\u879', '&#879;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U88">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u88')) then
                replace(replace(
                $value,
                '\\u884', '&#884;'), '\\u885', '&#885;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U89">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u89')) then
                replace(replace(replace(
                $value,
                '\\u891', '&#891;'), '\\u893', '&#893;'), '\\u894', '&#894;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U8">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u8')">
                <xsl:variable name="convertSpecialCharacters1U80">
                    <xsl:call-template name="decodeSpecialCharacters1U80">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U82">
                    <xsl:call-template name="decodeSpecialCharacters1U82">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U80"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U83">
                    <xsl:call-template name="decodeSpecialCharacters1U83">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U82"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U84">
                    <xsl:call-template name="decodeSpecialCharacters1U84">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U83"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U85">
                    <xsl:call-template name="decodeSpecialCharacters1U85">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U84"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U86">
                    <xsl:call-template name="decodeSpecialCharacters1U86">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U85"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U87">
                    <xsl:call-template name="decodeSpecialCharacters1U87">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U86"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U88">
                    <xsl:call-template name="decodeSpecialCharacters1U88">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U87"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U89">
                    <xsl:call-template name="decodeSpecialCharacters1U89">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U88"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U89"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U90">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u90')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u900', '&#900;'), '\\u902', '&#902;'), '\\u903', '&#903;'), '\\u904', '&#904;'), '\\u906', '&#906;'), '\\u908', '&#908;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U91">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u91')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u912', '&#912;'), '\\u913', '&#913;'), '\\u914', '&#914;'), '\\u915', '&#915;'), '\\u916', '&#916;'), '\\u917', '&#917;'), '\\u918', '&#918;'), '\\u919', '&#919;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U92">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u92')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u920', '&#920;'), '\\u921', '&#921;'), '\\u922', '&#922;'), '\\u923', '&#923;'), '\\u924', '&#924;'), '\\u925', '&#925;'), '\\u926', '&#926;'), '\\u927', '&#927;'), '\\u928', '&#928;'), '\\u929', '&#929;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U93">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u93')) then
                replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u931', '&#931;'), '\\u932', '&#932;'), '\\u933', '&#933;'), '\\u934', '&#934;'), '\\u935', '&#935;'), '\\u936', '&#936;'), '\\u937', '&#937;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U94">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u94')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u940', '&#940;'), '\\u941', '&#941;'), '\\u942', '&#942;'), '\\u943', '&#943;'), '\\u944', '&#944;'), '\\u945', '&#945;'), '\\u946', '&#946;'), '\\u947', '&#947;'), '\\u948', '&#948;'), '\\u949', '&#949;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U95">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u95')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u950', '&#950;'), '\\u951', '&#951;'), '\\u952', '&#952;'), '\\u953', '&#953;'), '\\u954', '&#954;'), '\\u955', '&#955;'), '\\u956', '&#956;'), '\\u957', '&#957;'), '\\u958', '&#958;'), '\\u959', '&#959;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U96">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u96')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u960', '&#960;'), '\\u961', '&#961;'), '\\u962', '&#962;'), '\\u963', '&#963;'), '\\u964', '&#964;'), '\\u965', '&#965;'), '\\u966', '&#966;'), '\\u967', '&#967;'), '\\u968', '&#968;'), '\\u969', '&#969;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U97">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u97')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u970', '&#970;'), '\\u971', '&#971;'), '\\u972', '&#972;'), '\\u973', '&#973;'), '\\u974', '&#974;'), '\\u977', '&#977;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U98">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u98')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u981', '&#981;'), '\\u985', '&#985;'), '\\u986', '&#986;'), '\\u987', '&#987;'), '\\u988', '&#988;'), '\\u989', '&#989;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U99">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u99')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u990', '&#990;'), '\\u991', '&#991;'), '\\u992', '&#992;'), '\\u993', '&#993;'), '\\u997', '&#997;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1U9">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u9')">
                <xsl:variable name="convertSpecialCharacters1U90">
                    <xsl:call-template name="decodeSpecialCharacters1U90">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U91">
                    <xsl:call-template name="decodeSpecialCharacters1U91">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U90"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U92">
                    <xsl:call-template name="decodeSpecialCharacters1U92">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U91"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U93">
                    <xsl:call-template name="decodeSpecialCharacters1U93">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U92"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U94">
                    <xsl:call-template name="decodeSpecialCharacters1U94">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U93"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U95">
                    <xsl:call-template name="decodeSpecialCharacters1U95">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U94"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U96">
                    <xsl:call-template name="decodeSpecialCharacters1U96">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U95"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U97">
                    <xsl:call-template name="decodeSpecialCharacters1U97">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U96"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U98">
                    <xsl:call-template name="decodeSpecialCharacters1U98">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U97"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U99">
                    <xsl:call-template name="decodeSpecialCharacters1U99">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U98"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U99"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters1">
        <xsl:param name="value"/>

        <xsl:variable name="convertSpecialCharacters1UC">
            <xsl:call-template name="decodeSpecialCharacters1UC">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($value, '\u')">
                <xsl:variable name="convertSpecialCharacters1U1">
                    <xsl:call-template name="decodeSpecialCharacters1U1">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1UC"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U2">
                    <xsl:call-template name="decodeSpecialCharacters1U2">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U3">
                    <xsl:call-template name="decodeSpecialCharacters1U3">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U2"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U4">
                    <xsl:call-template name="decodeSpecialCharacters1U4">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U3"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U5">
                    <xsl:call-template name="decodeSpecialCharacters1U5">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U4"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U6">
                    <xsl:call-template name="decodeSpecialCharacters1U6">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U5"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U7">
                    <xsl:call-template name="decodeSpecialCharacters1U7">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U6"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U8">
                    <xsl:call-template name="decodeSpecialCharacters1U8">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U7"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters1U9">
                    <xsl:call-template name="decodeSpecialCharacters1U9">
                        <xsl:with-param name="value" select="$convertSpecialCharacters1U8"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters1U9"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$convertSpecialCharacters1UC"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U100">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u100')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1001', '&#1001;'), '\\u1007', '&#1007;'), '\\u1008', '&#1008;'),
                '\\u10003', '&#10003;'),
                '\\u10013', '&#10013;'),
                '\\u10056', '&#10056;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U101">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u101')) then
                replace(
                $value,
                '\\u1010', '&#1010;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U102">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u102')) then
                replace(replace(replace(replace(
                $value,
                '\\u1022', '&#1022;'), '\\u1023', '&#1023;'), '\\u1024', '&#1024;'), '\\u1026', '&#1026;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U103">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u103')) then
                replace(replace(
                $value,
                '\\u1030', '&#1030;'), '\\u1034', '&#1034;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U104">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u104')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1040', '&#1040;'), '\\u1041', '&#1041;'), '\\u1042', '&#1042;'), '\\u1043', '&#1043;'), '\\u1044', '&#1044;'), '\\u1045', '&#1045;'), '\\u1046', '&#1046;'), '\\u1047', '&#1047;'), '\\u1048', '&#1048;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U105">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u105')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1050', '&#1050;'), '\\u1051', '&#1051;'), '\\u1052', '&#1052;'), '\\u1053', '&#1053;'), '\\u1054', '&#1054;'), '\\u1055', '&#1055;'), '\\u1056', '&#1056;'), '\\u1057', '&#1057;'), '\\u1058', '&#1058;'), '\\u1059', '&#1059;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U106">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u106')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1060', '&#1060;'), '\\u1061', '&#1061;'), '\\u1062', '&#1062;'), '\\u1063', '&#1063;'), '\\u1064', '&#1064;'), '\\u1065', '&#1065;'), '\\u1066', '&#1066;'), '\\u1067', '&#1067;'), '\\u1068', '&#1068;'), '\\u1069', '&#1069;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U107">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u107')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1070', '&#1070;'), '\\u1071', '&#1071;'), '\\u1072', '&#1072;'), '\\u1073', '&#1073;'), '\\u1074', '&#1074;'), '\\u1075', '&#1075;'), '\\u1076', '&#1076;'), '\\u1077', '&#1077;'), '\\u1078', '&#1078;'), '\\u1079', '&#1079;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U108">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u108')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1080', '&#1080;'), '\\u1081', '&#1081;'), '\\u1082', '&#1082;'), '\\u1083', '&#1083;'), '\\u1084', '&#1084;'), '\\u1085', '&#1085;'), '\\u1086', '&#1086;'), '\\u1087', '&#1087;'), '\\u1088', '&#1088;'), '\\u1089', '&#1089;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U109">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u109')) then
                replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1090', '&#1090;'), '\\u1091', '&#1091;'), '\\u1092', '&#1092;'), '\\u1093', '&#1093;'), '\\u1094', '&#1094;'), '\\u1095', '&#1095;'), '\\u1096', '&#1096;'), '\\u1097', '&#1097;'), '\\u1098', '&#1098;'), '\\u1099', '&#1099;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U10">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u10')">
                <xsl:variable name="convertSpecialCharacters2U100">
                    <xsl:call-template name="decodeSpecialCharacters2U100">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U101">
                    <xsl:call-template name="decodeSpecialCharacters2U101">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U100"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U102">
                    <xsl:call-template name="decodeSpecialCharacters2U102">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U101"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U103">
                    <xsl:call-template name="decodeSpecialCharacters2U103">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U102"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U104">
                    <xsl:call-template name="decodeSpecialCharacters2U104">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U103"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U105">
                    <xsl:call-template name="decodeSpecialCharacters2U105">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U104"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U106">
                    <xsl:call-template name="decodeSpecialCharacters2U106">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U105"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U107">
                    <xsl:call-template name="decodeSpecialCharacters2U107">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U106"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U108">
                    <xsl:call-template name="decodeSpecialCharacters2U108">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U107"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U109">
                    <xsl:call-template name="decodeSpecialCharacters2U109">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U108"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U109"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U110">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u110')) then
                replace(replace(replace(replace(
                $value,
                '\\u1100', '&#1100;'), '\\u1102', '&#1102;'), '\\u1103', '&#1103;'), '\\u1105', '&#1105;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U111">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u111')) then
                replace(
                $value,
                '\\u1110', '&#1110;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U112">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u112')) then
            replace(replace(
            $value,
            '\\u1122', '&#1122;'), '\\u1123', '&#1123;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U118">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u118')) then
            replace(replace(replace(
            $value,
            '\\u11819', '&#11819;'), '\\u11825', '&#11825;'), '\\u11833', '&#11833;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U11">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u11')">
                <xsl:variable name="convertSpecialCharacters2U110">
                    <xsl:call-template name="decodeSpecialCharacters2U110">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U111">
                    <xsl:call-template name="decodeSpecialCharacters2U111">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U110"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U112">
                    <xsl:call-template name="decodeSpecialCharacters2U112">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U111"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U118">
                    <xsl:call-template name="decodeSpecialCharacters2U118">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U112"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters2U118"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U12">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(replace(replace(
                $value,
                '\\u1237', '&#1237;'),
                '\\u1249', '&#1249;'),
                '\\u1265', '&#1265;')
                "/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U145">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(
                $value,
                '\\u1456', '&#1456;')
                "/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U146">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u146')) then
                replace(replace(replace(replace(
                $value,
                '\\u1460', '&#1460;'), '\\u1463', '&#1463;'), '\\u1465', '&#1465;'), '\\u1468', '&#1468;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U147">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u147')) then
                replace(replace(replace(
                $value,
                '\\u1472', '&#1472;'), '\\u1473', '&#1473;'), '\\u1476', '&#1476;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U148">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u148')) then
                replace(replace(
                $value,
                '\\u1488', '&#1488;'), '\\u1489', '&#1489;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U149">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u149')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1490', '&#1490;'), '\\u1491', '&#1491;'), '\\u1492', '&#1492;'), '\\u1493', '&#1493;'), '\\u1494', '&#1494;'),
                '\\u1495', '&#1495;'), '\\u1496', '&#1496;'), '\\u1497', '&#1497;'), '\\u1498', '&#1498;'), '\\u1499', '&#1499;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U14">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u14')">
                <xsl:variable name="convertSpecialCharacters2U145">
                    <xsl:call-template name="decodeSpecialCharacters2U145">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U146">
                    <xsl:call-template name="decodeSpecialCharacters2U146">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U145"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U147">
                    <xsl:call-template name="decodeSpecialCharacters2U147">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U146"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U148">
                    <xsl:call-template name="decodeSpecialCharacters2U148">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U147"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U149">
                    <xsl:call-template name="decodeSpecialCharacters2U149">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U148"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U149"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U150">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u150')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1500', '&#1500;'), '\\u1501', '&#1501;'), '\\u1502', '&#1502;'), '\\u1503', '&#1503;'), '\\u1504', '&#1504;'),
                '\\u1505', '&#1505;'), '\\u1506', '&#1506;'), '\\u1507', '&#1507;'), '\\u1508', '&#1508;'), '\\u1509', '&#1509;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U151">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u151')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u1510', '&#1510;'), '\\u1511', '&#1511;'), '\\u1512', '&#1512;'), '\\u1513', '&#1513;'), '\\u1514', '&#1514;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U156">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u156')) then
                replace(
                $value,
                '\\u1569', '&#1569;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U157">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u157')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1570', '&#1570;'), '\\u1571', '&#1571;'), '\\u1573', '&#1573;'), '\\u1575', '&#1575;'),
                '\\u1576', '&#1576;'), '\\u1577', '&#1577;'), '\\u1578', '&#1578;'), '\\u1579', '&#1579;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U158">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u158')) then
                replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1580', '&#1580;'), '\\u1581', '&#1581;'), '\\u1582', '&#1582;'), '\\u1583', '&#1583;'), '\\u1584', '&#1584;'),
                '\\u1585', '&#1585;'), '\\u1586', '&#1586;'), '\\u1587', '&#1587;'), '\\u1588', '&#1588;'), '\\u1589', '&#1589;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U159">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u159')) then
                replace(replace(replace(replace(replace(
                $value,
                '\\u1590', '&#1590;'), '\\u1591', '&#1591;'), '\\u1592', '&#1592;'), '\\u1593', '&#1593;'), '\\u1594', '&#1594;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U15">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u15')">
                <xsl:variable name="convertSpecialCharacters2U150">
                    <xsl:call-template name="decodeSpecialCharacters2U150">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U151">
                    <xsl:call-template name="decodeSpecialCharacters2U151">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U150"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U156">
                    <xsl:call-template name="decodeSpecialCharacters2U156">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U151"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U157">
                    <xsl:call-template name="decodeSpecialCharacters2U157">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U156"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U158">
                    <xsl:call-template name="decodeSpecialCharacters2U158">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U157"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U159">
                    <xsl:call-template name="decodeSpecialCharacters2U159">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U158"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters2U159"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U160">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u160')) then
                replace(
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u1601', '&#1601;'), '\\u1602', '&#1602;'), '\\u1603', '&#1603;'), '\\u1604', '&#1604;'), 
                '\\u1605', '&#1605;'), '\\u1606', '&#1606;'), '\\u1607', '&#1607;'), '\\u1608', '&#1608;'), '\\u1609', '&#1609;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U161">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u161')) then
                replace(replace(
                $value,
                '\\u1610', '&#1610;'), '\\u1615', '&#1615;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2U16">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u16')">
                <xsl:variable name="convertSpecialCharacters2U160">
                    <xsl:call-template name="decodeSpecialCharacters2U160">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U161">
                    <xsl:call-template name="decodeSpecialCharacters2U161">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U160"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters2U161"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters2">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u1')">
                <xsl:variable name="convertSpecialCharacters2U10">
                    <xsl:call-template name="decodeSpecialCharacters2U10">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U11">
                    <xsl:call-template name="decodeSpecialCharacters2U11">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U10"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U12">
                    <xsl:call-template name="decodeSpecialCharacters2U12">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U11"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U14">
                    <xsl:call-template name="decodeSpecialCharacters2U14">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U12"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U15">
                    <xsl:call-template name="decodeSpecialCharacters2U15">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U14"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters2U16">
                    <xsl:call-template name="decodeSpecialCharacters2U16">
                        <xsl:with-param name="value" select="$convertSpecialCharacters2U15"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters2U16"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U73">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u73')) then
            replace(replace(
            $value,
            '\\u7321', '&#7321;'), '\\u7325', '&#7325;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U74">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u74')) then
            replace(
            $value,
            '\\u7497', '&#7497;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U75">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u75')) then
            replace(replace(replace(replace(
            $value,
            '\\u7533', '&#7533;'), 
            '\\u7545', '&#7545;'),
            '\\u7580', '&#7580;'),
            '\\u7584', '&#7584;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U76">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u76')) then
                replace(replace(replace(replace(
                $value,
                '\\u7624', '&#7624;'), '\\u7625', '&#7625;'), 
                '\\u7694', '&#7694;'), '\\u7695', '&#7695;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U771">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u771')) then
                replace(replace(replace(
                $value,
                '\\u7712', '&#7712;'), '\\u7716', '&#7716;'), '\\u7717', '&#7717;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U773">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u773')) then
                replace(replace(replace(
                $value,
                '\\u7730', '&#7730;'), '\\u7731', '&#7731;'), '\\u7733', '&#7733;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U777">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u777')) then
                replace(replace(
                $value,
                '\\u7778', '&#7778;'), '\\u7779', '&#7779;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U778">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u778')) then
                replace(replace(
                $value,
                '\\u7788', '&#7788;'), '\\u7789', '&#7789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U779">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u779')) then
                replace(replace(
                $value,
                '\\u7790', '&#7790;'), '\\u7791', '&#7791;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U77">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u77')">
                <xsl:variable name="convertSpecialCharacters3U771">
                    <xsl:call-template name="decodeSpecialCharacters3U771">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U773">
                    <xsl:call-template name="decodeSpecialCharacters3U773">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U771"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U777">
                    <xsl:call-template name="decodeSpecialCharacters3U777">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U773"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U778">
                    <xsl:call-template name="decodeSpecialCharacters3U778">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U777"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U779">
                    <xsl:call-template name="decodeSpecialCharacters3U779">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U778"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U779"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U780">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u780')) then
                replace(replace(
                $value,
                '\\u7804', '&#7804;'), '\\u7807', '&#7807;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U781">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u781')) then
            replace(replace(
            $value,
            '\\u7811', '&#7811;'), '\\u7813', '&#7813;')
            else
            $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U782">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u782')) then
                replace(replace(
                $value,
                '\\u7822', '&#7822;'), '\\u7823', '&#7823;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U783">
        <xsl:param name="value"/>
        <xsl:value-of select="
                replace(replace(
                $value,
                '\\u7832', '&#7832;'),
                '\\u7869', '&#7869;')
                "/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U78">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u78')">
                <xsl:variable name="convertSpecialCharacters3U780">
                    <xsl:call-template name="decodeSpecialCharacters3U780">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U781">
                    <xsl:call-template name="decodeSpecialCharacters3U781">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U780"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U782">
                    <xsl:call-template name="decodeSpecialCharacters3U782">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U781"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U783">
                    <xsl:call-template name="decodeSpecialCharacters3U783">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U782"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:value-of select="$convertSpecialCharacters3U783"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U79">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u79')) then
                replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(
                $value,
                '\\u7911', '&#7911;'),
                '\\u7923', '&#7923;'),
                '\\u7931', '&#7931;'), '\\u7936', '&#7936;'), '\\u7937', '&#7937;'), '\\u7938', '&#7938;'), '\\u7939', '&#7939;'),
                '\\u7940', '&#7940;'), '\\u7941', '&#7941;'), '\\u7942', '&#7942;'), '\\u7943', '&#7943;'), '\\u7944', '&#7944;'), '\\u7945', '&#7945;'), '\\u7946', '&#7946;'), '\\u7947', '&#7947;'), '\\u7948', '&#7948;'), '\\u7949', '&#7949;'),
                '\\u7950', '&#7950;'), '\\u7952', '&#7952;'), '\\u7953', '&#7953;'), '\\u7954', '&#7954;'), '\\u7955', '&#7955;'), '\\u7956', '&#7956;'), '\\u7957', '&#7957;'),
                '\\u7960', '&#7960;'), '\\u7961', '&#7961;'), '\\u7962', '&#7962;'), '\\u7963', '&#7963;'), '\\u7964', '&#7964;'), '\\u7965', '&#7965;'), '\\u7968', '&#7968;'), '\\u7969', '&#7969;'),
                '\\u7970', '&#7970;'), '\\u7971', '&#7971;'), '\\u7972', '&#7972;'), '\\u7973', '&#7973;'), '\\u7974', '&#7974;'), '\\u7975', '&#7975;'), '\\u7976', '&#7976;'), '\\u7977', '&#7977;'), '\\u7978', '&#7978;'), '\\u7979', '&#7979;'),
                '\\u7980', '&#7980;'), '\\u7981', '&#7981;'), '\\u7982', '&#7982;'), '\\u7983', '&#7983;'), '\\u7984', '&#7984;'), '\\u7985', '&#7985;'), '\\u7986', '&#7986;'), '\\u7987', '&#7987;'), '\\u7988', '&#7988;'), '\\u7989', '&#7989;'),
                '\\u7990', '&#7990;'), '\\u7991', '&#7991;'), '\\u7992', '&#7992;'), '\\u7993', '&#7993;'), '\\u7996', '&#7996;'), '\\u7997', '&#7997;'), '\\u7998', '&#7998;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U7">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u7')">
                <xsl:variable name="convertSpecialCharacters3U73">
                    <xsl:call-template name="decodeSpecialCharacters3U73">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U74">
                    <xsl:call-template name="decodeSpecialCharacters3U74">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U73"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U75">
                    <xsl:call-template name="decodeSpecialCharacters3U75">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U74"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U76">
                    <xsl:call-template name="decodeSpecialCharacters3U76">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U75"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U77">
                    <xsl:call-template name="decodeSpecialCharacters3U77">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U76"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U78">
                    <xsl:call-template name="decodeSpecialCharacters3U78">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U77"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U79">
                    <xsl:call-template name="decodeSpecialCharacters3U79">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U78"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters3U79"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U80">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u80')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(
                $value,
                '\\u8000', '&#8000;'), '\\u8001', '&#8001;'), '\\u8002', '&#8002;'), '\\u8003', '&#8003;'), '\\u8004', '&#8004;'), '\\u8005', '&#8005;'), '\\u8008', '&#8008;'), '\\u8009', '&#8009;'),
                '\\u8011', '&#8011;'), '\\u8012', '&#8012;'), '\\u8013', '&#8013;'), '\\u8016', '&#8016;'), '\\u8017', '&#8017;'), '\\u8019', '&#8019;'),
                '\\u8020', '&#8020;'), '\\u8021', '&#8021;'), '\\u8022', '&#8022;'), '\\u8023', '&#8023;'), '\\u8025', '&#8025;'), '\\u8029', '&#8029;'),
                '\\u8032', '&#8032;'), '\\u8033', '&#8033;'), '\\u8034', '&#8034;'), '\\u8035', '&#8035;'), '\\u8036', '&#8036;'), '\\u8037', '&#8037;'), '\\u8038', '&#8038;'), '\\u8039', '&#8039;'),
                '\\u8040', '&#8040;'), '\\u8041', '&#8041;'), '\\u8042', '&#8042;'), '\\u8043', '&#8043;'), '\\u8044', '&#8044;'), '\\u8045', '&#8045;'), '\\u8046', '&#8046;'), '\\u8047', '&#8047;'), '\\u8048', '&#8048;'), '\\u8049', '&#8049;'),
                '\\u8050', '&#8050;'), '\\u8051', '&#8051;'), '\\u8052', '&#8052;'), '\\u8053', '&#8053;'), '\\u8054', '&#8054;'), '\\u8055', '&#8055;'), '\\u8056', '&#8056;'), '\\u8057', '&#8057;'), '\\u8058', '&#8058;'), '\\u8059', '&#8059;'),
                '\\u8060', '&#8060;'), '\\u8061', '&#8061;'), '\\u8064', '&#8064;'), '\\u8068', '&#8068;'), '\\u8069', '&#8069;'),
                '\\u8070', '&#8070;'), '\\u8077', '&#8077;'),
                '\\u8080', '&#8080;'), '\\u8081', '&#8081;'), '\\u8082', '&#8082;'), '\\u8084', '&#8084;'), '\\u8085', '&#8085;'), '\\u8086', '&#8086;'), '\\u8087', '&#8087;'),
                '\\u8096', '&#8096;'), '\\u8099', '&#8099;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U81">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u81')) then
                replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(
                $value,
                '\\u8100', '&#8100;'), '\\u8102', '&#8102;'), '\\u8103', '&#8103;'), '\\u8104', '&#8104;'),
                '\\u8113', '&#8113;'), '\\u8115', '&#8115;'), '\\u8116', '&#8116;'), '\\u8118', '&#8118;'), '\\u8119', '&#8119;'),
                '\\u8125', '&#8125;'), '\\u8127', '&#8127;'), '\\u8128', '&#8128;'),
                '\\u8131', '&#8131;'), '\\u8132', '&#8132;'), '\\u8134', '&#8134;'), '\\u8135', '&#8135;'),
                '\\u8141', '&#8141;'), '\\u8142', '&#8142;'), '\\u8143', '&#8143;'), '\\u8145', '&#8145;'), '\\u8146', '&#8146;'), '\\u8147', '&#8147;'),
                '\\u8150', '&#8150;'), '\\u8157', '&#8157;'), '\\u8158', '&#8158;'), '\\u8159', '&#8159;'),
                '\\u8160', '&#8160;'), '\\u8161', '&#8161;'), '\\u8162', '&#8162;'), '\\u8163', '&#8163;'), '\\u8164', '&#8164;'), '\\u8165', '&#8165;'), '\\u8166', '&#8166;'),
                '\\u8172', '&#8172;'), '\\u8174', '&#8174;'), '\\u8175', '&#8175;'), '\\u8178', '&#8178;'), '\\u8179', '&#8179;'),
                '\\u8180', '&#8180;'), '\\u8182', '&#8182;'), '\\u8183', '&#8183;'), '\\u8185', '&#8185;'), '\\u8188', '&#8188;'), '\\u8189', '&#8189;'),
                '\\u8190', '&#8190;'), '\\u8193', '&#8193;'), '\\u8194', '&#8194;'), '\\u8198', '&#8198;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U82">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u82')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(replace(
                $value,
                '\\u8202', '&#8202;'), '\\u8203', '&#8203;'), '\\u8204', '&#8204;'), '\\u8206', '&#8206;'), '\\u8209', '&#8209;'),
                '\\u8210', '&#8210;'), '\\u8213', '&#8213;'), '\\u8214', '&#8214;'), '\\u8218', '&#8218;'), '\\u8219', '&#8219;'),
                '\\u8222', '&#8222;'), '\\u8223', '&#8223;'), '\\u8224', '&#8224;'), '\\u8225', '&#8225;'),
                '\\u8230', '&#8230;'), '\\u8239', '&#8239;'),
                '\\u8242', '&#8242;'), '\\u8249', '&#8249;'),
                '\\u8250', '&#8250;'), '\\u8251', '&#8251;'), '\\u8254', '&#8254;'),
                '\\u8278', '&#8278;'),
                '\\u8285', '&#8285;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U83">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u83')) then
                replace(replace(
                $value,
                '\\u8356', '&#8356;'),
                '\\u8364', '&#8364;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U84">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u84')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u8452', '&#8452;'),
                '\\u8464', '&#8464;'), '\\u8466', '&#8466;'), '\\u8468', '&#8468;'),
                '\\u8470', '&#8470;'), '\\u8478', '&#8478;'),
                '\\u8482', '&#8482;'), '\\u8483', '&#8483;'), '\\u8485', '&#8485;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U85">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u85')) then
                replace(replace(replace(replace(replace(replace(replace(replace(
                $value,
                '\\u8531', '&#8531;'), '\\u8532', '&#8532;'), '\\u8533', '&#8533;'), '\\u8537', '&#8537;'),
                '\\u8544', '&#8544;'),
                '\\u8592', '&#8592;'), '\\u8593', '&#8593;'), '\\u8594', '&#8594;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U86">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(
            $value,
            '\\u8670', '&#8670;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U87">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u87')) then
                replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
                replace(replace(
                $value,
                '\\u8709', '&#8709;'),
                '\\u8710', '&#8710;'), '\\u8711', '&#8711;'),
                '\\u8722', '&#8722;'), '\\u8729', '&#8729;'),
                '\\u8730', '&#8730;'), '\\u8734', '&#8734;'),
                '\\u8741', '&#8741;'), '\\u8747', '&#8747;'),
                '\\u8756', '&#8756;'), '\\u8759', '&#8759;'),
                '\\u8776', '&#8776;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U88">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u88')) then
                replace(replace(
                $value,
                '\\u8805', '&#8805;'),
                '\\u8857', '&#8857;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U890">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u890')) then
                replace(replace(replace(
                $value,
                '\\u8901', '&#8901;'), '\\u8902', '&#8902;'), '\\u8904', '&#8904;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U899">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(
            $value,
            '\\u8992', '&#8992;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U89">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u89')">
                <xsl:variable name="convertSpecialCharacters3U890">
                    <xsl:call-template name="decodeSpecialCharacters3U890">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U899">
                    <xsl:call-template name="decodeSpecialCharacters3U899">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U890"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U899"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U8">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u8')">
                <xsl:variable name="convertSpecialCharacters3U80">
                    <xsl:call-template name="decodeSpecialCharacters3U80">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U81">
                    <xsl:call-template name="decodeSpecialCharacters3U81">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U80"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U82">
                    <xsl:call-template name="decodeSpecialCharacters3U82">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U81"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U83">
                    <xsl:call-template name="decodeSpecialCharacters3U83">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U82"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U84">
                    <xsl:call-template name="decodeSpecialCharacters3U84">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U83"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U85">
                    <xsl:call-template name="decodeSpecialCharacters3U85">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U84"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U86">
                    <xsl:call-template name="decodeSpecialCharacters3U86">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U85"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U87">
                    <xsl:call-template name="decodeSpecialCharacters3U87">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U86"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U88">
                    <xsl:call-template name="decodeSpecialCharacters3U88">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U87"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U89">
                    <xsl:call-template name="decodeSpecialCharacters3U89">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U88"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U89"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U90">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u900')) then
                replace(replace(
                $value,
                '\\u9001', '&#9001;'), '\\u9002', '&#9002;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U95">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u95')) then
                replace(
                $value,
                '\\u9553', '&#9553;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U96">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u96')) then
                replace(replace(replace(replace(
                $value,
                '\\u9660', '&#9660;'),'\\u9674', '&#9674;'), '\\u9675', '&#9675;'), '\\u9679', '&#9679;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U970">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u97')) then
                replace(replace(replace(replace(
                $value,
                '\\u9702', '&#9702;'),
                '\\u9737', '&#9737;'),
                '\\u9769', '&#9769;'),
                '\\u9789', '&#9789;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U979">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u979')) then
                replace(replace(replace(replace(replace(replace(
                $value,
                '\\u9790', '&#9790;'), '\\u9791', '&#9791;'), '\\u9792', '&#9792;'), '\\u9793', '&#9793;'), '\\u9794', '&#9794;'), '\\u9797', '&#9797;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U97">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u97')">
                <xsl:variable name="convertSpecialCharacters3U970">
                    <xsl:call-template name="decodeSpecialCharacters3U970">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U979">
                    <xsl:call-template name="decodeSpecialCharacters3U979">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U970"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="$convertSpecialCharacters3U979"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U98">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u98')) then
                replace(
                $value,
                '\\u9830', '&#9830;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U99">
        <xsl:param name="value"/>
        <xsl:value-of select="
            if (contains($value, '\u99')) then
                replace(
                $value,
                '\\u9991', '&#9991;')
            else
                $value"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3U9">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\u9')">
                <xsl:variable name="convertSpecialCharacters3U90">
                    <xsl:call-template name="decodeSpecialCharacters3U90">
                        <xsl:with-param name="value" select="$value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U95">
                    <xsl:call-template name="decodeSpecialCharacters3U95">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U90"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U96">
                    <xsl:call-template name="decodeSpecialCharacters3U96">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U95"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U97">
                    <xsl:call-template name="decodeSpecialCharacters3U97">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U96"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U98">
                    <xsl:call-template name="decodeSpecialCharacters3U98">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U97"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="convertSpecialCharacters3U99">
                    <xsl:call-template name="decodeSpecialCharacters3U99">
                        <xsl:with-param name="value" select="$convertSpecialCharacters3U98"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$convertSpecialCharacters3U99"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters3">
        <xsl:param name="value"/>

        <xsl:variable name="convertSpecialCharacters3U7">
            <xsl:call-template name="decodeSpecialCharacters3U7">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="convertSpecialCharacters3U8">
            <xsl:call-template name="decodeSpecialCharacters3U8">
                <xsl:with-param name="value" select="$convertSpecialCharacters3U7"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="convertSpecialCharacters3U9">
            <xsl:call-template name="decodeSpecialCharacters3U9">
                <xsl:with-param name="value" select="$convertSpecialCharacters3U8"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$convertSpecialCharacters3U9"/>

    </xsl:template>
    <xsl:template name="decodeSpecialCharacters40">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\^')">
                <xsl:value-of select="
                    replace(replace(replace(replace(replace(replace(replace(replace(
                    replace(replace(replace(replace(replace(replace(replace(replace(
                    $value,
                    '\\\^96', '&#x96;'),
                    '\\\^9c', '&#x153;'),
                    '\\\^92', '’'),
                    '\\\^ab', '&#xab;'),
                    '\\\^b0', '&#xb0;'),
                    '\\\^b7', '&#xb7;'),
                    '\\\^bb', '&#xbb;'),
                    '\\\^c9', '&#xc9;'),
                    '\\\^e0', '&#xe0;'),
                    '\\\^e4', '&#xe4;'),
                    '\\\^e8', '&#xe8;'),
                    '\\\^e9', '&#xe9;'),
                    '\\\^ea', '&#xea;'),
                    '\\\^d6', '&#xd6;'),
                    '\\\^f4', '&#xf4;'),
                    '\\\^fc', '&#xfc;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters41">
        <xsl:param name="value"/>
        <xsl:value-of select="
            replace(replace(replace(
            $value,
            '&lt;',             '&#x2039;'),
            '&gt;',             '&#x203A;'),
            '&amp;',            '&amp;amp;')"/>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters42">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="contains($value, '\')">
                <xsl:value-of select="
                    replace(replace(replace(replace(replace(replace(replace(replace(replace(
                    $value,
                    '\\emdash', '&#x2014;'),
                    '\\endash ', '&#x2013;'),
                    ' ?\\lquote ',   '‘'),
                    '\\ldblquote ',  '“'),
                    '\\rquote ',     '’'),
                    ' ?\\rdblquote', '”'),
                    '\. ?\. ?\.',    '&#x2026;'),
                    '\\~',           '&#x00A0;'),
                    '\\\-',          '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="decodeSpecialCharacters4">
        <xsl:param name="value"/>
        <xsl:variable name="convertSpecialCharacters40">
            <xsl:call-template name="decodeSpecialCharacters40">
                <xsl:with-param name="value" select="$value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters41">
            <xsl:call-template name="decodeSpecialCharacters41">
                <xsl:with-param name="value" select="$convertSpecialCharacters40"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="convertSpecialCharacters42">
            <xsl:call-template name="decodeSpecialCharacters42">
                <xsl:with-param name="value" select="$convertSpecialCharacters41"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$convertSpecialCharacters42"/>
    </xsl:template>

</xsl:stylesheet>