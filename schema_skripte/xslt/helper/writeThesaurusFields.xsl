<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:h1="http://www.startext.de/HiDA/DefService/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    extension-element-prefixes="saxon"
      exclude-result-prefixes="#all"
    version="3.0">

    <xsl:param name="normdatenServer">https://normdaten.staatsbibliothek-berlin.de/hsp/vocabulary/</xsl:param>

  <xsl:template name="writeThesaurusField">
    <xsl:param name="field"/>
    <xsl:param name="notation"/>
    <xsl:param name="typeOfInformation"/>
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="$notation = ''">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="indexName" select="'norm_form'"/>
          <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="'form'"/>
            <xsl:value-of select="$value"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="starts-with($notation, 'FORM-X')">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="indexName" select="'norm_form'"/>
          <xsl:for-each select="tokenize($notation, ' ')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
              <xsl:choose>
                <xsl:when test="starts-with(., 'BNDG-X')"><xsl:attribute name="type" select="'binding'"/></xsl:when>
                <xsl:when test="starts-with(., 'CODC-A')"><xsl:attribute name="type" select="'material_type'"/></xsl:when>
                <xsl:when test="starts-with(., 'FORM-X')"><xsl:attribute name="type" select="'form'"/></xsl:when>
                <xsl:when test="starts-with(., 'FORM-')"><xsl:attribute name="type" select="'form_keyFeature'"/></xsl:when>
              </xsl:choose>
              <xsl:call-template name="writeReferences">
                <xsl:with-param name="notation" select="."/>
              </xsl:call-template>
              <xsl:if test="starts-with(., 'FORM-X')"><xsl:value-of select="$value"/></xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:when test="starts-with($notation, 'FORM-')">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="indexName" select="'norm_form'"/>
          <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="'form'"/>
          </xsl:element>
          <xsl:for-each select="tokenize($notation, ' ')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
              <xsl:attribute name="type" select="'form_keyFeature'"/>
              <xsl:call-template name="writeReferences">
                <xsl:with-param name="notation" select="."/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:when test="starts-with($notation, 'CODC-A')">
        <xsl:for-each select="tokenize($notation, ' ')">
          <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
              <xsl:when test="starts-with(., 'BNDG-X')"><xsl:attribute name="type" select="'binding'"/></xsl:when>
              <xsl:when test="starts-with(., 'CODC-A')"><xsl:attribute name="type" select="'material_type'"/></xsl:when>
              <xsl:when test="starts-with(., 'CODC-B')"><xsl:attribute name="type" select="'format'"/></xsl:when>
              <xsl:when test="starts-with(., 'FORM-X')"><xsl:attribute name="type" select="'form'"/></xsl:when>
              <xsl:when test="starts-with(., 'FORM-')"><xsl:attribute name="type" select="'form_keyFeature'"/></xsl:when>
            </xsl:choose>
            <xsl:call-template name="writeReferences"><xsl:with-param name="notation" select="."/>
            </xsl:call-template>
            <xsl:value-of select="$value"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="starts-with($notation, 'CODC-B')">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="indexName" select="'norm_format'"/>
          <xsl:for-each select="tokenize($notation, ' ')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
              <xsl:choose>
                <xsl:when test="starts-with(., 'BNDG-X')"><xsl:attribute name="type" select="'binding'"/></xsl:when>
                <xsl:when test="starts-with(., 'CODC-A')"><xsl:attribute name="type" select="'material_type'"/></xsl:when>
                <xsl:when test="starts-with(., 'CODC-B')"><xsl:attribute name="type" select="'format'"/></xsl:when>
                <xsl:when test="starts-with(., 'FORM-X')"><xsl:attribute name="type" select="'form'"/></xsl:when>
                <xsl:when test="starts-with(., 'FORM-')"><xsl:attribute name="type" select="'form_keyFeature'"/></xsl:when>
              </xsl:choose>
              <xsl:call-template name="writeReferences">
                <xsl:with-param name="notation" select="."/>
              </xsl:call-template>
              <xsl:value-of select="$value"/>
            </xsl:element>
          </xsl:for-each>
          <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="type" select="'format_typeOfInformation'"/>
            <xsl:choose>
              <xsl:when test="$typeOfInformation != ''"><xsl:value-of select="$typeOfInformation"/></xsl:when>
              <xsl:when test="contains($value, 'ERRECHNET')">computed</xsl:when>
              <xsl:when test="$value != '' ">factual</xsl:when>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="starts-with($notation, 'SCRP')">
        <xsl:element name="index" namespace="http://www.tei-c.org/ns/1.0">
          <xsl:attribute name="indexName">Schriftart</xsl:attribute>
          <xsl:for-each select="tokenize($notation, ' ')">
            <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
              <xsl:attribute name="type" select="'script'"/>
              <xsl:call-template name="writeReferences"><xsl:with-param name="notation" select="."/></xsl:call-template>
              <xsl:value-of select="$value"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="tokenize($notation, ' ')">
          <xsl:element name="term" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
              <xsl:when test="starts-with(., 'BNDG-X')"><xsl:attribute name="type" select="'binding'"/></xsl:when>
              <xsl:when test="starts-with(., 'CODC-A')"><xsl:attribute name="type" select="'material_type'"/></xsl:when>
              <xsl:when test="starts-with(., 'CODC-B')"><xsl:attribute name="type" select="'format'"/></xsl:when>
              <xsl:when test="starts-with(., 'FORM-X')"><xsl:attribute name="type" select="'form'"/></xsl:when>
              <xsl:when test="starts-with(., 'FORM-')"><xsl:attribute name="type" select="'form_keyFeature'"/></xsl:when>
              <xsl:when test="starts-with(., 'SCRP-')"><xsl:attribute name="type" select="'script'"/></xsl:when>
            </xsl:choose>
            <xsl:call-template name="writeReferences"><xsl:with-param name="notation" select="."/></xsl:call-template>
            <xsl:choose>
              <xsl:when test="starts-with(., 'CODC-A')"><xsl:value-of select="$value"/></xsl:when>
              <xsl:when test="starts-with(., 'FORM-X')"><xsl:value-of select="$value"/></xsl:when>
              <xsl:when test="starts-with(., 'SCRP')"><xsl:value-of select="$value"/></xsl:when>
            </xsl:choose>
          </xsl:element>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:variable name="writeReferencesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'FORM-A263'" select="'NORM-e5cb8ab1-d859-3f87-aa5c-b74c0646ae2b'"/>
      <xsl:map-entry key="'FORM-A890'" select="'NORM-fcdc9965-677e-3c69-9a70-0c266893e376'"/>
      <xsl:map-entry key="'FORM-B170'" select="'NORM-f07b4aca-bf67-3120-9454-bd7e4bcf4904'"/>
      <xsl:map-entry key="'FORM-B400'" select="'NORM-bd1f496f-8236-3beb-a54f-079fe3a14f81'"/>
      <xsl:map-entry key="'FORM-B456'" select="'NORM-c93ac08a-42e4-3f13-bea2-ed07dfea9892'"/>
      <xsl:map-entry key="'FORM-B905'" select="'NORM-74709cd6-b0cb-3975-8026-855ebea0b652'"/>
      <xsl:map-entry key="'FORM-C102'" select="'NORM-9693f53a-8a5b-3a2a-a43b-cb94995d3441'"/>
      <xsl:map-entry key="'FORM-C187'" select="'NORM-66d55950-1724-3948-a713-d9ff95a9a3cb'"/>
      <xsl:map-entry key="'FORM-C688'" select="'NORM-25a7e96e-cf69-3419-897a-9476f202bf00'"/>
      <xsl:map-entry key="'FORM-D359'" select="'NORM-3efb4a02-145e-3830-8c14-c1ae4cf21e16'"/>
      <xsl:map-entry key="'FORM-D412'" select="'NORM-05c4a096-de99-3978-bad1-8c030f4a56f7'"/>
      <xsl:map-entry key="'FORM-D888'" select="'NORM-3e11cecd-211e-360a-a590-27e23d3a05be'"/>
      <xsl:map-entry key="'FORM-E137'" select="'NORM-056d2dac-d848-333f-b6a3-8ef645247ea0'"/>
      <xsl:map-entry key="'FORM-E156'" select="'NORM-7073017b-2b8d-3d54-8918-5872004670cf'"/>
      <xsl:map-entry key="'FORM-E159'" select="'NORM-d5a1accc-6f10-3a3e-9961-bb1a55298ffe'"/>
      <xsl:map-entry key="'FORM-E161'" select="'NORM-a7172eed-475a-324a-ab29-80d7319f1f3b'"/>
      <xsl:map-entry key="'FORM-E235'" select="'NORM-cde71269-29df-3eb4-b40c-c433218bcbc2'"/>
      <xsl:map-entry key="'FORM-E248'" select="'NORM-67ebfba4-92fd-34d2-8253-9312cbd7478d'"/>
      <xsl:map-entry key="'FORM-E266'" select="'NORM-50ef4963-68cf-31af-8924-5590db266057'"/>
      <xsl:map-entry key="'FORM-E318'" select="'NORM-d037417c-124f-358c-83e4-885b1cc1e5d1'"/>
      <xsl:map-entry key="'FORM-E324'" select="'NORM-4b57546c-c642-3a00-86fc-27820344657a'"/>
      <xsl:map-entry key="'FORM-E333'" select="'NORM-9022ee40-f17b-3bc6-bf46-ddabb0052b12'"/>
      <xsl:map-entry key="'FORM-E350'" select="'NORM-5dcac9ee-2a31-3245-bddf-6e1f4c22478e'"/>
      <xsl:map-entry key="'FORM-E361'" select="'NORM-6ac9fbe3-99c1-3e24-be03-82ba19d93f31'"/>
      <xsl:map-entry key="'FORM-E389'" select="'NORM-615e97ce-dc2e-311e-a6fa-556a704db9c0'"/>
      <xsl:map-entry key="'FORM-E429'" select="'NORM-d8be542d-20bd-323d-8240-97e7806d4645'"/>
      <xsl:map-entry key="'FORM-E460'" select="'NORM-2cc5aa64-911a-3f25-9a5c-7f11b4386553'"/>
      <xsl:map-entry key="'FORM-E505'" select="'NORM-a39bb6f3-6707-396f-b45c-80c80bb98eea'"/>
      <xsl:map-entry key="'FORM-E518'" select="'NORM-90e91c23-577f-380d-bb5f-bd7eafde706f'"/>
      <xsl:map-entry key="'FORM-E547'" select="'NORM-b439ee7e-6f77-3f55-bcc1-8898c1f7fbd0'"/>
      <xsl:map-entry key="'FORM-E612'" select="'NORM-005b3040-e680-30ac-afcb-69251989d78d'"/>
      <xsl:map-entry key="'FORM-E666'" select="'NORM-891c18c3-f92f-3363-8a70-9913c0e2ccbc'"/>
      <xsl:map-entry key="'FORM-E760'" select="'NORM-ca688960-82cf-3ad0-bb35-d1ff6d03350c'"/>
      <xsl:map-entry key="'FORM-E772'" select="'NORM-3286f43f-4d9f-3193-9a13-5a5e298ecb39'"/>
      <xsl:map-entry key="'FORM-E822'" select="'NORM-66b0b6e8-72c9-3303-9dd5-6e12b8756fe3'"/>
      <xsl:map-entry key="'FORM-E840'" select="'NORM-f80c41a0-b683-304d-b14c-d9e7adc2456b'"/>
      <xsl:map-entry key="'FORM-E938'" select="'NORM-ac87f76d-e91b-33a5-8a78-b007967816ae'"/>
      <xsl:map-entry key="'FORM-E947'" select="'NORM-c822b379-f3f4-3c1a-9cb7-bfd1e3868dc9'"/>
      <xsl:map-entry key="'FORM-E992'" select="'NORM-ace87a01-166e-3d3b-b314-ae97ea5f6d13'"/>
      <xsl:map-entry key="'FORM-F104'" select="'NORM-7065641f-6a3c-37a0-9abe-226019e3f0ab'"/>
      <xsl:map-entry key="'FORM-F163'" select="'NORM-5de093e2-85bb-331a-bb66-89926fa78c49'"/>
      <xsl:map-entry key="'FORM-F164'" select="'NORM-213b0bde-ed67-3df2-8acb-2752a1dd78e9'"/>
      <xsl:map-entry key="'FORM-F183'" select="'NORM-bfbdff0f-a274-33d2-9d55-9a6eeb840da4'"/>
      <xsl:map-entry key="'FORM-F188'" select="'NORM-25b9f604-768c-3ef4-8bce-1aa5477bb22d'"/>
      <xsl:map-entry key="'FORM-F189'" select="'NORM-5393895c-a30e-396d-9b91-f78152bd2bc8'"/>
      <xsl:map-entry key="'FORM-F215'" select="'NORM-e4bd68d6-cde1-336e-ab60-4a7c1097c05b'"/>
      <xsl:map-entry key="'FORM-F224'" select="'NORM-cce3c5fb-57f6-3c33-9451-55402394e075'"/>
      <xsl:map-entry key="'FORM-F268'" select="'NORM-d3543424-d1c6-3093-8c53-8da3ce2eb294'"/>
      <xsl:map-entry key="'FORM-F282'" select="'NORM-2faf5a7e-714f-3385-aa83-d7019ce3bd64'"/>
      <xsl:map-entry key="'FORM-F343'" select="'NORM-f7dd4a37-3909-385e-a252-963c3c2f6b93'"/>
      <xsl:map-entry key="'FORM-F354'" select="'NORM-455459ac-f1f8-30df-92ab-430031b4d26c'"/>
      <xsl:map-entry key="'FORM-F394'" select="'NORM-4e523d82-df5a-3bd1-b13c-8b8efe3a2832'"/>
      <xsl:map-entry key="'FORM-F399'" select="'NORM-33e1fc90-87f2-32c0-837f-509d2e2ccdb5'"/>
      <xsl:map-entry key="'FORM-F417'" select="'NORM-594cc2b5-f71a-323b-863c-1fb577f4328d'"/>
      <xsl:map-entry key="'FORM-F429'" select="'NORM-80fa8134-5943-3c58-88f0-1600d698c297'"/>
      <xsl:map-entry key="'FORM-F431'" select="'NORM-4d7e6841-53fe-3f50-bfeb-15fd42c83c0a'"/>
      <xsl:map-entry key="'FORM-F454'" select="'NORM-e42c5ace-9d01-38e0-b587-074e0a757c1d'"/>
      <xsl:map-entry key="'FORM-F463'" select="'NORM-f93ac095-ac2d-3951-bc03-d16179af2648'"/>
      <xsl:map-entry key="'FORM-F556'" select="'NORM-5a90cc5a-2d5b-39e9-b82e-8c391f68e1b3'"/>
      <xsl:map-entry key="'FORM-F631'" select="'NORM-4bcd1116-9b05-3814-b2ff-7f72ac5ffed3'"/>
      <xsl:map-entry key="'FORM-F682'" select="'NORM-bea98244-ea4d-314e-b9a8-f36102aa2437'"/>
      <xsl:map-entry key="'FORM-F690'" select="'NORM-8003b391-b78b-3427-8c7f-670295199b59'"/>
      <xsl:map-entry key="'FORM-F695'" select="'NORM-7bff46b7-4bd0-3514-bd29-a5910b40d985'"/>
      <xsl:map-entry key="'FORM-F739'" select="'NORM-ecc36ab0-61e5-3a66-b149-2a03a41006a3'"/>
      <xsl:map-entry key="'FORM-F744'" select="'NORM-b9c53f9f-3c3b-3d19-b21f-fe7e859daaf6'"/>
      <xsl:map-entry key="'FORM-F796'" select="'NORM-aeb6dd33-dbb2-3e0f-b416-a65f74ee7007'"/>
      <xsl:map-entry key="'FORM-F852'" select="'NORM-4e4096ee-414f-392d-bb53-b3379d1e9ad3'"/>
      <xsl:map-entry key="'FORM-F888'" select="'NORM-fa846c77-118b-35a3-bbed-d129979b784b'"/>
      <xsl:map-entry key="'FORM-F942'" select="'NORM-e2505226-2f24-3fbb-bb4a-15a79c7d8535'"/>
      <xsl:map-entry key="'FORM-F980'" select="'NORM-af954aee-d546-316e-9263-08f4d3e87946'"/>
      <xsl:map-entry key="'FORM-F996'" select="'NORM-ebd441b6-8e2d-3c08-8859-452b88fe261d'"/>
      <xsl:map-entry key="'FORM-X160'" select="'NORM-93efb825-a5bd-3ed6-9008-48893b848d5f'"/>
      <xsl:map-entry key="'FORM-X236'" select="'NORM-98f525a5-519b-3922-9477-b03a4a6daa4a'"/>
      <xsl:map-entry key="'FORM-X287'" select="'NORM-0ebf4218-5e5f-3c34-8121-877113c3eeb5'"/>
      <xsl:map-entry key="'FORM-X320'" select="'NORM-49455f63-f959-3a94-98ee-1921aed20a25'"/>
      <xsl:map-entry key="'FORM-X321'" select="'NORM-1c873b93-30c4-39d6-8ac2-97e5d6a1599a'"/>
      <xsl:map-entry key="'FORM-X358'" select="'NORM-718405ed-2d31-3952-b877-c2dd1f631f17'"/>
      <xsl:map-entry key="'FORM-X377'" select="'NORM-1855adbe-7620-3f21-b867-7fd575b51b61'"/>
      <xsl:map-entry key="'FORM-X445'" select="'NORM-8638bd06-6ca8-3b67-a236-5b85a0fc3143'"/>
      <xsl:map-entry key="'FORM-X446'" select="'NORM-269b3fdb-d9e4-3ff1-90b8-369fad2a8b83'"/>
      <xsl:map-entry key="'FORM-X451'" select="'NORM-89d523f7-2e81-30bc-801e-5414441b0bc5'"/>
      <xsl:map-entry key="'FORM-X453'" select="'NORM-b891ff91-1ff4-38ed-90e4-025c7a3f1ece'"/>
      <xsl:map-entry key="'FORM-X462'" select="'NORM-ba1cd1cf-ffb6-38aa-a0ac-c0a35f5e5bcc'"/>
      <xsl:map-entry key="'FORM-X543'" select="'NORM-a67ce672-18b5-3165-b60d-2552cc371d14'"/>
      <xsl:map-entry key="'FORM-X545'" select="'NORM-1eb41f42-223e-3793-a803-074141f47fdb'"/>
      <xsl:map-entry key="'FORM-X568'" select="'NORM-2ec7b946-ff64-32ed-b745-0c896c90561d'"/>
      <xsl:map-entry key="'FORM-X677'" select="'NORM-65fcc77c-dd07-3ea9-8718-124170f01dfb'"/>
      <xsl:map-entry key="'FORM-X709'" select="'NORM-8edc413b-0b70-3366-b78c-fdc091ab3ab2'"/>
      <xsl:map-entry key="'FORM-X738'" select="'NORM-dfbfa04a-5676-39a4-bc37-a29d39d75d1a'"/>
      <xsl:map-entry key="'FORM-X822'" select="'NORM-0542970e-45d5-3e72-a89d-38dbde7d04a1'"/>
      <xsl:map-entry key="'FORM-X832'" select="'NORM-209496d6-c53a-3336-88e5-a4f11df93091'"/>
      <xsl:map-entry key="'FORM-X869'" select="'NORM-385d6995-a735-3a4c-a8b0-221b21cccf01'"/>
      <xsl:map-entry key="'FORM-X963'" select="'NORM-5144cb76-a2e0-3f67-a12f-1eeed50aba77'"/>

      <xsl:map-entry key="'CODC-A117'" select="'NORM-ef5b9838-217c-34a2-aa19-fca7b02431db'"/>
      <xsl:map-entry key="'CODC-A194'" select="'NORM-cb40acd0-d326-3c9d-96f8-39fa0fdc79d7'"/>
      <xsl:map-entry key="'CODC-A325'" select="'NORM-0645572a-5f58-3143-a29f-7b0622bb4efe'"/>
      <xsl:map-entry key="'CODC-A366'" select="'NORM-9150b6ae-291d-331a-992f-1df68095932a'"/>
      <xsl:map-entry key="'CODC-A480'" select="'NORM-f04f6978-99cf-3605-9af9-c09b76547b93'"/>
      <xsl:map-entry key="'CODC-A491'" select="'NORM-9b73cf2a-8505-3a41-bf9f-7db7eab93fe9'"/>
      <xsl:map-entry key="'CODC-A601'" select="'NORM-a892fa2c-a5a4-3a7b-97b8-963c6ce0dcfe'"/>
      <xsl:map-entry key="'CODC-A635'" select="'NORM-6ed837be-3832-37a2-9168-cc492a221d1b'"/>
      <xsl:map-entry key="'CODC-A645'" select="'NORM-9588a773-13d7-337e-a3e3-1c4462e7ad55'"/>
      <xsl:map-entry key="'CODC-A653'" select="'NORM-66c13260-3c3f-39ca-8fcc-3d0d652da932'"/>
      <xsl:map-entry key="'CODC-A725'" select="'NORM-c1c884d8-955d-3020-a77f-5d2be6df1f7b'"/>
      <xsl:map-entry key="'CODC-A773'" select="'NORM-95a86c7e-d885-3f8a-8354-10112ab515a6'"/>
      <xsl:map-entry key="'CODC-A783'" select="'NORM-a0de4403-be48-3766-8fff-b94933a285fe'"/>
      <xsl:map-entry key="'CODC-A794'" select="'NORM-0f3a0c8e-b574-34ce-8d2b-dcae203aae1a'"/>
      <xsl:map-entry key="'CODC-A797'" select="'NORM-e6843434-3a76-3a3b-a9d1-5af22349f065'"/>
      <xsl:map-entry key="'CODC-A800'" select="'NORM-e7b1c101-919e-3fdb-983b-762c305fdcc1'"/>
      <xsl:map-entry key="'CODC-A839'" select="'NORM-5fe53b21-ae46-34d0-b1a8-e35571fdc8e2'"/>
      <xsl:map-entry key="'CODC-A915'" select="'NORM-c78f6c61-c2af-3090-af01-6c4c8bda3a2b'"/>
      <xsl:map-entry key="'CODC-A959'" select="'NORM-d8c2f12a-ba75-335c-95d2-acf8bc097647'"/>
      <xsl:map-entry key="'CODC-B199'" select="'NORM-44661283-359d-3efa-bd85-f1ac28eef209'"/>
      <xsl:map-entry key="'CODC-B200'" select="'NORM-3a7f56d3-8e73-3893-8ed5-11e19ac9710b'"/>
      <xsl:map-entry key="'CODC-B234'" select="'NORM-761dcbb4-1961-36d9-ad14-2cb32e2e519c'"/>
      <xsl:map-entry key="'CODC-B460'" select="'NORM-496f92b2-2bdd-3756-b49c-ab886e93dfba'"/>
      <xsl:map-entry key="'CODC-B653'" select="'NORM-75b68a55-7be1-35bc-9eaa-a66800f7902b'"/>
      <xsl:map-entry key="'CODC-B727'" select="'NORM-1aef1e53-277d-3398-ada7-1c1b28a7e0c6'"/>
      <xsl:map-entry key="'CODC-B742'" select="'NORM-1d418d34-4806-3149-ace4-2bed58bdfec8'"/>
      <xsl:map-entry key="'CODC-B865'" select="'NORM-14b14026-fe97-3743-9a4a-acf58cc3edc5'"/>
      <xsl:map-entry key="'CODC-B978'" select="'NORM-1aa147bb-3fad-3603-bab8-d754366c33a6'"/>
      <xsl:map-entry key="'CODC-C189'" select="'NORM-e9ed44d8-cfe2-3e82-8f29-bf59282cbe90'"/>
      <xsl:map-entry key="'CODC-C267'" select="'NORM-9e39444b-f4a5-3109-acd9-2ba3c01da85a'"/>
      <xsl:map-entry key="'CODC-C335'" select="'NORM-b4b992e3-5485-359f-860f-3bc670b0234c'"/>
      <xsl:map-entry key="'CODC-C394'" select="'NORM-7f921806-e1a1-3f25-a9b1-165d4d31b343'"/>
      <xsl:map-entry key="'CODC-C429'" select="'NORM-b0c45ccb-ab1b-32e0-8388-302267813d3d'"/>
      <xsl:map-entry key="'CODC-C465'" select="'NORM-1d955e43-5e44-39c2-abee-2e9f994060b9'"/>
      <xsl:map-entry key="'CODC-C495'" select="'NORM-2cdb0bb9-220a-3f5e-bae4-ec72d25e216c'"/>
      <xsl:map-entry key="'CODC-C588'" select="'NORM-dfb84dd8-b269-3a64-8a15-b8b6c08fd663'"/>
      <xsl:map-entry key="'CODC-C636'" select="'NORM-257a7fb5-488f-30b8-990a-084b68f7493a'"/>
      <xsl:map-entry key="'CODC-C935'" select="'NORM-91a4ddca-51cd-3a41-98f5-19c3d5362ed7'"/>
      <xsl:map-entry key="'CODC-C978'" select="'NORM-4fa69696-0f92-3468-b080-b0000854186f'"/>
      <xsl:map-entry key="'CODC-D127'" select="'NORM-a0b5c751-c212-3ed9-9b65-0426b45b066e'"/>
      <xsl:map-entry key="'CODC-D149'" select="'NORM-25c0154c-d665-3c7c-b171-c97969ecf244'"/>
      <xsl:map-entry key="'CODC-D177'" select="'NORM-d49272a7-c846-3d08-a4cc-c392d8d76067'"/>
      <xsl:map-entry key="'CODC-D187'" select="'NORM-6bad6e98-65c4-3c3e-9c88-ff254c872519'"/>
      <xsl:map-entry key="'CODC-D210'" select="'NORM-dc2fb257-5d46-309c-abc2-4b3ce4feaafe'"/>
      <xsl:map-entry key="'CODC-D223'" select="'NORM-1d572f31-5850-3a79-88db-546a1785971f'"/>
      <xsl:map-entry key="'CODC-D252'" select="'NORM-4d5ad8e2-4e0a-397b-b4da-cefe61562ee0'"/>
      <xsl:map-entry key="'CODC-D276'" select="'NORM-005ce754-4767-33cd-b74e-d7c3a4f85bb9'"/>
      <xsl:map-entry key="'CODC-D299'" select="'NORM-91f6168d-d0fc-39dd-b0a4-f67adaee4425'"/>
      <xsl:map-entry key="'CODC-D318'" select="'NORM-5c16f896-d757-37bb-bc2f-f351e8d11db0'"/>
      <xsl:map-entry key="'CODC-D358'" select="'NORM-18423231-44a2-3f81-ba0b-769c32bcd529'"/>
      <xsl:map-entry key="'CODC-D387'" select="'NORM-b54aa6cf-b682-3ffe-adc4-16fbec16fddc'"/>
      <xsl:map-entry key="'CODC-D400'" select="'NORM-a529a352-3880-365d-8ad1-eead91f8f018'"/>
      <xsl:map-entry key="'CODC-D425'" select="'NORM-83b25221-f1ee-3907-bb87-8de08944efec'"/>
      <xsl:map-entry key="'CODC-D458'" select="'NORM-d4efd376-9524-3ecf-9f17-beec1d278922'"/>
      <xsl:map-entry key="'CODC-D483'" select="'NORM-dcfd71ea-cd97-31ac-889d-38758c992e1e'"/>
      <xsl:map-entry key="'CODC-D511'" select="'NORM-4791ffe9-525c-378c-b255-15d1b6cea4a2'"/>
      <xsl:map-entry key="'CODC-D541'" select="'NORM-abeeb3cd-ad8d-3352-b85a-8a8cceeb5e82'"/>
      <xsl:map-entry key="'CODC-D571'" select="'NORM-d711d91e-64ea-3f21-8ba4-32227907ec01'"/>
      <xsl:map-entry key="'CODC-D608'" select="'NORM-5e8c4fcf-ab1d-37e2-a302-690d190b6a03'"/>
      <xsl:map-entry key="'CODC-D611'" select="'NORM-ab6b7801-4c2c-32ee-8817-160bfea381d5'"/>
      <xsl:map-entry key="'CODC-D614'" select="'NORM-6f148b5c-098d-378d-8240-1c0f0ade1c7d'"/>
      <xsl:map-entry key="'CODC-D653'" select="'NORM-aef8abe5-f952-31aa-b221-826707eea8fb'"/>
      <xsl:map-entry key="'CODC-D677'" select="'NORM-0acf7e61-b38f-3635-97d7-380475fc4c0c'"/>
      <xsl:map-entry key="'CODC-D680'" select="'NORM-2f0f2a42-2718-3753-a9db-a0bd47b775b7'"/>
      <xsl:map-entry key="'CODC-D704'" select="'NORM-6a23a1f5-0cab-3dbc-ba19-a2499413b167'"/>
      <xsl:map-entry key="'CODC-D736'" select="'NORM-72cca02d-cc02-3fce-b405-383272cc8c71'"/>
      <xsl:map-entry key="'CODC-D742'" select="'NORM-2fe6c91f-8955-3c1c-8818-3a4c8dc77e73'"/>
      <xsl:map-entry key="'CODC-D765'" select="'NORM-82923ef0-b81a-3b58-83f6-3bfa78d90de8'"/>
      <xsl:map-entry key="'CODC-D772'" select="'NORM-a4da9170-e544-343a-8a76-c375055ffe3d'"/>
      <xsl:map-entry key="'CODC-D782'" select="'NORM-cc53c631-b862-3188-a499-f2b9e2dee769'"/>
      <xsl:map-entry key="'CODC-D791'" select="'NORM-b06bd42f-6d22-3dc9-9d66-4dd2f86f9761'"/>
      <xsl:map-entry key="'CODC-D793'" select="'NORM-09b76874-9616-38d0-bf9e-c050bd8251d7'"/>
      <xsl:map-entry key="'CODC-D912'" select="'NORM-83d1e5c7-4c20-327d-8a31-a5c37ec1fb2d'"/>

      <xsl:map-entry key="'BNDG-A180'" select="'NORM-821ba04d-895d-3e45-970b-3a93d5a7ab7f'"/>
      <xsl:map-entry key="'BNDG-A206'" select="'NORM-2ce4fc63-ba6e-3026-a440-62a4b8e9642f'"/>
      <xsl:map-entry key="'BNDG-A239'" select="'NORM-f3bd05cd-c31d-314b-bafa-cda21482d0c0'"/>
      <xsl:map-entry key="'BNDG-A284'" select="'NORM-e2f86653-17df-3aa8-98e6-19722454124c'"/>
      <xsl:map-entry key="'BNDG-A343'" select="'NORM-bdf90ca7-680c-3791-83c6-13ded902bd33'"/>
      <xsl:map-entry key="'BNDG-A345'" select="'NORM-02dc5af4-364a-37b1-a035-aa54168f14c4'"/>
      <xsl:map-entry key="'BNDG-A415'" select="'NORM-c47f976e-aba5-36ad-8a0e-d962b14d01e8'"/>
      <xsl:map-entry key="'BNDG-A460'" select="'NORM-1727e64f-d87c-34a8-a07c-ae1d6d569d71'"/>
      <xsl:map-entry key="'BNDG-A507'" select="'NORM-75d4cbe0-0e1f-3ed4-a01a-dc3bdf56493c'"/>
      <xsl:map-entry key="'BNDG-A532'" select="'NORM-ac703c4f-45c9-3940-9def-d71b8e5b5fc3'"/>
      <xsl:map-entry key="'BNDG-A960'" select="'NORM-42f87478-1152-339d-8093-f78a56dc1e82'"/>
      <xsl:map-entry key="'BNDG-B118'" select="'NORM-1b8d5c1e-9b0c-3de0-8f34-21c6b8f5ef3d'"/>
      <xsl:map-entry key="'BNDG-B260'" select="'NORM-6993660a-e1f4-3565-9ba3-fec900e47dea'"/>
      <xsl:map-entry key="'BNDG-B285'" select="'NORM-7f20442e-c19f-3f54-9dcc-3ee441f5644d'"/>
      <xsl:map-entry key="'BNDG-B329'" select="'NORM-af593adc-65d9-385c-8883-ecfcba779efd'"/>
      <xsl:map-entry key="'BNDG-B478'" select="'NORM-47298c03-938d-39b3-8665-e78aaaf9de5f'"/>
      <xsl:map-entry key="'BNDG-B548'" select="'NORM-2110968e-294f-3ab8-b168-75436b7948ff'"/>
      <xsl:map-entry key="'BNDG-B561'" select="'NORM-90d8afaf-f26c-3241-ab0a-928afb3dbfa3'"/>
      <xsl:map-entry key="'BNDG-B568'" select="'NORM-c7353c06-d538-3256-b6bb-e44f56dc8bec'"/>
      <xsl:map-entry key="'BNDG-B699'" select="'NORM-700b02d0-d07d-381f-9ead-bebac8424662'"/>
      <xsl:map-entry key="'BNDG-B726'" select="'NORM-ca34eca0-ad40-36d4-abae-893bfb47d15d'"/>
      <xsl:map-entry key="'BNDG-B783'" select="'NORM-aaf0f40b-0703-3a30-8724-a8b413d36c38'"/>
      <xsl:map-entry key="'BNDG-B854'" select="'NORM-8592059c-10a3-3418-99e9-e168b0abe21a'"/>
      <xsl:map-entry key="'BNDG-B859'" select="'NORM-1a02603b-bc5d-323d-869d-0e33d83a1412'"/>
      <xsl:map-entry key="'BNDG-B869'" select="'NORM-9b56f422-a95c-39fa-9669-652d3331d1a7'"/>
      <xsl:map-entry key="'BNDG-B964'" select="'NORM-e72f66c5-8444-33a7-88ca-2e7bfdf8800a'"/>
      <xsl:map-entry key="'BNDG-B993'" select="'NORM-f1e41003-d238-3515-ab37-30f426a6e252'"/>
      <xsl:map-entry key="'BNDG-C105'" select="'NORM-3df6f684-041c-3ac2-baa3-fd47b552394d'"/>
      <xsl:map-entry key="'BNDG-C142'" select="'NORM-1ac8b905-74ec-343d-9ec1-486bfd219f1d'"/>
      <xsl:map-entry key="'BNDG-C175'" select="'NORM-24d2b12a-a072-3548-b83e-e79cdd69028b'"/>
      <xsl:map-entry key="'BNDG-C225'" select="'NORM-a659d4dd-5e6c-3624-b2a3-2572f2f220cc'"/>
      <xsl:map-entry key="'BNDG-C231'" select="'NORM-e8690945-fe78-348b-8024-31bf9c3cd001'"/>
      <xsl:map-entry key="'BNDG-C237'" select="'NORM-09528518-add6-3f57-8e92-476a12b5ab26'"/>
      <xsl:map-entry key="'BNDG-C306'" select="'NORM-fdff88c9-9776-366c-8378-c09a61d721f3'"/>
      <xsl:map-entry key="'BNDG-C348'" select="'NORM-ec5276b6-fe59-354a-b671-b1e9f837a722'"/>
      <xsl:map-entry key="'BNDG-C380'" select="'NORM-e09d2b9b-f231-3274-a097-41b561d3befb'"/>
      <xsl:map-entry key="'BNDG-C506'" select="'NORM-70dab0c2-254a-31dd-b940-9f4957d356ad'"/>
      <xsl:map-entry key="'BNDG-C577'" select="'NORM-95657a34-afe4-30ce-98c1-e4704b31e248'"/>
      <xsl:map-entry key="'BNDG-C607'" select="'NORM-371685d3-38a3-32e3-addb-320957dd66c8'"/>
      <xsl:map-entry key="'BNDG-C666'" select="'NORM-3f9def04-1fcf-3d5b-ab02-1a97e5be7db6'"/>
      <xsl:map-entry key="'BNDG-C932'" select="'NORM-2568830e-0194-3397-9bf0-b3535a96e795'"/>
      <xsl:map-entry key="'BNDG-C986'" select="'NORM-11a62a01-8a4e-3470-b3dd-f2a1d0084667'"/>
      <xsl:map-entry key="'BNDG-D123'" select="'NORM-d03e0ede-ec98-3728-8d4f-5a50e0cf6f1a'"/>
      <xsl:map-entry key="'BNDG-D138'" select="'NORM-4d98d800-d8af-3eca-a7a6-b0b655298dab'"/>
      <xsl:map-entry key="'BNDG-D174'" select="'NORM-b2fefc2d-d79c-3221-b46c-8faebe8bb6eb'"/>
      <xsl:map-entry key="'BNDG-D235'" select="'NORM-8a290f5b-bab0-31c6-900e-b4c63d35edab'"/>
      <xsl:map-entry key="'BNDG-D253'" select="'NORM-a552312e-7387-3625-b49a-5c319623721d'"/>
      <xsl:map-entry key="'BNDG-D341'" select="'NORM-51022592-e3c0-30de-887b-f0a7e5b00d2c'"/>
      <xsl:map-entry key="'BNDG-D354'" select="'NORM-090fb8fc-54c9-3a6d-a8b0-10690366a440'"/>
      <xsl:map-entry key="'BNDG-D367'" select="'NORM-4df08386-3ebd-3830-95ff-6c67bce8bde6'"/>
      <xsl:map-entry key="'BNDG-D401'" select="'NORM-1c9d82d6-cb5e-30bb-a860-36c7c986b4b9'"/>
      <xsl:map-entry key="'BNDG-D431'" select="'NORM-85d70460-c7ff-3637-a2d2-82ec52692a3b'"/>
      <xsl:map-entry key="'BNDG-D586'" select="'NORM-c5e06fbd-b235-3015-83bf-0c0c09f98bbc'"/>
      <xsl:map-entry key="'BNDG-D624'" select="'NORM-5481a6b6-95a1-36bf-b85a-83061b0b5665'"/>
      <xsl:map-entry key="'BNDG-D630'" select="'NORM-2a50641e-6f05-3af0-96e7-85391db62018'"/>
      <xsl:map-entry key="'BNDG-D738'" select="'NORM-6f37e2c3-ebfd-3503-852e-90da99314cb6'"/>
      <xsl:map-entry key="'BNDG-D745'" select="'NORM-32e47e21-261b-3fb6-a28d-f106bd1b4490'"/>
      <xsl:map-entry key="'BNDG-D803'" select="'NORM-f805b2d9-3da4-3e0a-b550-be01694b2a31'"/>
      <xsl:map-entry key="'BNDG-D864'" select="'NORM-3545f756-1288-3ef9-ac0b-76f1cbf803d8'"/>
      <xsl:map-entry key="'BNDG-D898'" select="'NORM-febe8860-1ab2-3bfd-838f-aa8e1167d4ad'"/>
      <xsl:map-entry key="'BNDG-D930'" select="'NORM-7a13baa1-59c3-3ba1-85f7-eb87b7b0f9bd'"/>
      <xsl:map-entry key="'BNDG-D941'" select="'NORM-b419518a-8e55-3424-a93f-12b553b8b679'"/>
      <xsl:map-entry key="'BNDG-D971'" select="'NORM-154f9d62-e7be-321e-bc99-1d7cae52ef1c'"/>
      <xsl:map-entry key="'BNDG-E150'" select="'NORM-6fe20019-6bec-344a-b06d-fe6145db0c79'"/>
      <xsl:map-entry key="'BNDG-E155'" select="'NORM-d4f02c5d-d9a2-3f00-bc16-7c79988efee4'"/>
      <xsl:map-entry key="'BNDG-E179'" select="'NORM-1eae3a21-564b-3e9c-9918-c0f5167d0377'"/>
      <xsl:map-entry key="'BNDG-E235'" select="'NORM-b481c64c-bcea-30a1-bad4-b28804be3da0'"/>
      <xsl:map-entry key="'BNDG-E244'" select="'NORM-2f443bec-cf95-3da6-8c31-107c5fd48509'"/>
      <xsl:map-entry key="'BNDG-E317'" select="'NORM-0a7349f5-1168-321c-ac05-87a7acdffcd5'"/>
      <xsl:map-entry key="'BNDG-E336'" select="'NORM-31790938-96ac-34ec-bade-1b7b0de34b64'"/>
      <xsl:map-entry key="'BNDG-E340'" select="'NORM-6ad90514-dd49-3acd-8e9c-b39fe96fb787'"/>
      <xsl:map-entry key="'BNDG-E359'" select="'NORM-a3f47b25-fece-37f8-8d74-085f0445b830'"/>
      <xsl:map-entry key="'BNDG-E418'" select="'NORM-794fc366-406c-3377-9eca-78be3caade73'"/>
      <xsl:map-entry key="'BNDG-E428'" select="'NORM-04f120c3-9194-3d0f-99cb-6e25252d35f3'"/>
      <xsl:map-entry key="'BNDG-E456'" select="'NORM-bf20acd0-b850-3405-90eb-5ddb5334d5d9'"/>
      <xsl:map-entry key="'BNDG-E491'" select="'NORM-f716201e-fa38-34dc-9839-387973c3411e'"/>
      <xsl:map-entry key="'BNDG-E574'" select="'NORM-66f4793d-a47e-3fac-9b4d-6f955116ce58'"/>
      <xsl:map-entry key="'BNDG-E613'" select="'NORM-51262c68-6b75-35da-b800-a4f90e2d45bc'"/>
      <xsl:map-entry key="'BNDG-E625'" select="'NORM-36acf876-d855-3360-bed2-8c9c2bea5e56'"/>
      <xsl:map-entry key="'BNDG-E642'" select="'NORM-d33c0ea7-a492-381d-a19b-a806296a3a00'"/>
      <xsl:map-entry key="'BNDG-E672'" select="'NORM-9d431476-8b95-31a0-9dbe-6cdd8e5d3181'"/>
      <xsl:map-entry key="'BNDG-E697'" select="'NORM-5449189a-4215-3a0e-b8c9-85863d960adb'"/>
      <xsl:map-entry key="'BNDG-E698'" select="'NORM-f6b9cad8-89bd-36ac-93fd-34ea8afff452'"/>
      <xsl:map-entry key="'BNDG-E702'" select="'NORM-7156b67d-f316-33d7-af9d-3f41348ba8db'"/>
      <xsl:map-entry key="'BNDG-E739'" select="'NORM-09fbff20-eb35-35a5-86f5-67c15f458007'"/>
      <xsl:map-entry key="'BNDG-E741'" select="'NORM-4caa1861-fa6f-39b7-b443-54b28f647bef'"/>
      <xsl:map-entry key="'BNDG-E746'" select="'NORM-d5201867-c794-3548-98c7-65ef52848a41'"/>
      <xsl:map-entry key="'BNDG-E757'" select="'NORM-e357d5e8-79bc-3cb2-9bc7-7dafbcd6d2b6'"/>
      <xsl:map-entry key="'BNDG-E798'" select="'NORM-adbffb33-cb8b-37af-9e0b-d9ca4cee6895'"/>
      <xsl:map-entry key="'BNDG-E801'" select="'NORM-4d1a10a1-a4d1-3b0b-b2db-dfd435662f1e'"/>
      <xsl:map-entry key="'BNDG-E824'" select="'NORM-fcd835e9-f38a-3bf2-a2e5-9b006b5ad6eb'"/>
      <xsl:map-entry key="'BNDG-E851'" select="'NORM-4d9a5e26-3f90-3d64-8ae3-c0eb69f67ec4'"/>
      <xsl:map-entry key="'BNDG-E913'" select="'NORM-e27c5e4f-d9a1-3579-b1db-0c4d01dafec9'"/>
      <xsl:map-entry key="'BNDG-E978'" select="'NORM-434c5521-b635-3e8d-ba76-e36e129cc516'"/>
      <xsl:map-entry key="'BNDG-F122'" select="'NORM-cf4b6bec-33da-3a55-b7b1-ba048df8ff9d'"/>
      <xsl:map-entry key="'BNDG-F124'" select="'NORM-ee028de2-4d3d-3008-8de6-050ba8f029bc'"/>
      <xsl:map-entry key="'BNDG-F142'" select="'NORM-6fbf881d-dc24-3548-a088-5b547a14a9e3'"/>
      <xsl:map-entry key="'BNDG-F173'" select="'NORM-9311ac5c-8aea-3312-ae06-82cd3a9594a3'"/>
      <xsl:map-entry key="'BNDG-F293'" select="'NORM-65cc2dc4-f81c-327e-9a21-79695a90ebad'"/>
      <xsl:map-entry key="'BNDG-F297'" select="'NORM-44703e90-d2d2-3258-8bcf-725a4fed7a4d'"/>
      <xsl:map-entry key="'BNDG-F310'" select="'NORM-56498745-5a67-38e7-a575-2a29e3f28eba'"/>
      <xsl:map-entry key="'BNDG-F414'" select="'NORM-4d7b6764-e19d-3035-a5ee-f0a14ed81bd6'"/>
      <xsl:map-entry key="'BNDG-F468'" select="'NORM-21d862ca-c205-346c-87a7-d703b8b96af6'"/>
      <xsl:map-entry key="'BNDG-F501'" select="'NORM-0fec8aab-7a1c-3560-a482-1c025fdce01c'"/>
      <xsl:map-entry key="'BNDG-F549'" select="'NORM-7080406a-dcf1-3950-b665-a8bf22014b1b'"/>
      <xsl:map-entry key="'BNDG-F571'" select="'NORM-a009f400-7ab7-3334-9d05-dd1f2e381f36'"/>
      <xsl:map-entry key="'BNDG-F619'" select="'NORM-8bba1731-f0b5-3cbb-8f1c-9894ce57c0e2'"/>
      <xsl:map-entry key="'BNDG-F682'" select="'NORM-6722e193-6ac4-36ec-b210-5878b8b7bd5a'"/>
      <xsl:map-entry key="'BNDG-F748'" select="'NORM-3cecbf01-d73b-3955-952a-c16d5fbcbfe8'"/>
      <xsl:map-entry key="'BNDG-F807'" select="'NORM-3c0caee6-6d90-3779-b1b7-b1766746e979'"/>
      <xsl:map-entry key="'BNDG-F863'" select="'NORM-53ef5994-5350-34a2-a3c6-a79f555e2b06'"/>
      <xsl:map-entry key="'BNDG-F868'" select="'NORM-cf7e881a-234f-3e97-b4a9-812781af7128'"/>
      <xsl:map-entry key="'BNDG-F946'" select="'NORM-3c11081f-9b89-3cb6-8ab0-24da6f5a802b'"/>
      <xsl:map-entry key="'BNDG-F971'" select="'NORM-4e0ee2ec-6701-3165-a023-f2432b18e4a1'"/>
      <xsl:map-entry key="'BNDG-G108'" select="'NORM-c1629a99-ff71-3e78-8388-0d751f6d1269'"/>
      <xsl:map-entry key="'BNDG-G114'" select="'NORM-d7af2a6c-833c-3b4e-a217-8cab48442998'"/>
      <xsl:map-entry key="'BNDG-G117'" select="'NORM-64facc7e-2387-328b-a3f7-43b8bca59c08'"/>
      <xsl:map-entry key="'BNDG-G124'" select="'NORM-7e1588f7-c685-3db4-9377-bde3cfc1366c'"/>
      <xsl:map-entry key="'BNDG-G152'" select="'NORM-aaa2b7a4-7cb6-3e3e-a777-83bd355d3e1c'"/>
      <xsl:map-entry key="'BNDG-G153'" select="'NORM-53474446-83d7-3494-bccd-9c3cad5f50f7'"/>
      <xsl:map-entry key="'BNDG-G163'" select="'NORM-3e9c136a-9ca2-3d74-89f9-1be69a2b8dc7'"/>
      <xsl:map-entry key="'BNDG-G188'" select="'NORM-af91e9c2-5207-39c6-a1bf-a315a7bb3ac9'"/>
      <xsl:map-entry key="'BNDG-G215'" select="'NORM-17cc55c0-6477-37f8-b094-6376d0385b60'"/>
      <xsl:map-entry key="'BNDG-G218'" select="'NORM-7a48931b-08b2-31b5-b7ca-b97b2b64b31f'"/>
      <xsl:map-entry key="'BNDG-G242'" select="'NORM-d4977f41-e245-35de-8a80-f12e424b33a3'"/>
      <xsl:map-entry key="'BNDG-G245'" select="'NORM-cd35317a-b98f-365e-a1b7-e47a799d10d7'"/>
      <xsl:map-entry key="'BNDG-G246'" select="'NORM-402939f6-559a-3e8c-847c-265479e8e4b6'"/>
      <xsl:map-entry key="'BNDG-G248'" select="'NORM-0701260e-eb99-31bc-bf5e-0040d6d9b59e'"/>
      <xsl:map-entry key="'BNDG-G253'" select="'NORM-5870448c-a211-39be-b43c-439b14ce25c1'"/>
      <xsl:map-entry key="'BNDG-G270'" select="'NORM-005770c5-00b9-3e24-910d-93eabdcbf306'"/>
      <xsl:map-entry key="'BNDG-G292'" select="'NORM-51df2586-1d47-38d1-9855-1a75561ab089'"/>
      <xsl:map-entry key="'BNDG-G308'" select="'NORM-94f5f6b3-16b6-301b-8188-7657665a4c91'"/>
      <xsl:map-entry key="'BNDG-G420'" select="'NORM-31de833d-a934-3e00-802c-aa8051c410cb'"/>
      <xsl:map-entry key="'BNDG-G430'" select="'NORM-564546fb-64b6-3e04-a794-ad20b0646948'"/>
      <xsl:map-entry key="'BNDG-G437'" select="'NORM-af918434-ad3d-3de5-94cb-4f7227c6bd81'"/>
      <xsl:map-entry key="'BNDG-G446'" select="'NORM-7b5852b1-a2f6-33ae-89d8-6c6e56554e77'"/>
      <xsl:map-entry key="'BNDG-G463'" select="'NORM-ac8a861f-d513-39cb-b5cc-b395eef33e66'"/>
      <xsl:map-entry key="'BNDG-G489'" select="'NORM-e5846c41-f075-36f4-96af-5d297cf1457e'"/>
      <xsl:map-entry key="'BNDG-G494'" select="'NORM-7bd86f40-7c9f-3ab7-a4fd-1b5a80f30a59'"/>
      <xsl:map-entry key="'BNDG-G502'" select="'NORM-4a8aa4a3-e71c-3929-ac3f-c72fedd6b6ac'"/>
      <xsl:map-entry key="'BNDG-G512'" select="'NORM-df1b527a-ae07-3601-b9d8-c8d049f87b8f'"/>
      <xsl:map-entry key="'BNDG-G525'" select="'NORM-64fa0b63-9af1-3269-8c78-4299ee63e519'"/>
      <xsl:map-entry key="'BNDG-G550'" select="'NORM-336e9ef1-e966-3841-b69e-3dea4dc725d5'"/>
      <xsl:map-entry key="'BNDG-G607'" select="'NORM-f011a141-e777-3666-ad90-e59a874ddaa9'"/>
      <xsl:map-entry key="'BNDG-G617'" select="'NORM-bf930d06-efa0-3434-90e2-2444275183f0'"/>
      <xsl:map-entry key="'BNDG-G655'" select="'NORM-d22b1060-c7dd-3b40-9fd5-054bed98a1f6'"/>
      <xsl:map-entry key="'BNDG-G696'" select="'NORM-74e173b1-c6e1-3d90-b4ea-4fd9dd6b7348'"/>
      <xsl:map-entry key="'BNDG-G699'" select="'NORM-99a7b7f3-a2e9-3409-9bfe-49ecc8f70c77'"/>
      <xsl:map-entry key="'BNDG-G720'" select="'NORM-d88d24fd-ef3f-31b2-8e7b-e1ec39963619'"/>
      <xsl:map-entry key="'BNDG-G747'" select="'NORM-246c837f-4119-3ba0-b302-4cf6eb834e03'"/>
      <xsl:map-entry key="'BNDG-G818'" select="'NORM-2b1df75a-5249-33d5-af4f-156f786cca40'"/>
      <xsl:map-entry key="'BNDG-G862'" select="'NORM-f9afde71-7c96-36ad-b3d1-95382d957ba5'"/>
      <xsl:map-entry key="'BNDG-G863'" select="'NORM-b88dc796-38c4-3579-bb75-3f40e35dc9aa'"/>
      <xsl:map-entry key="'BNDG-G870'" select="'NORM-977f9dec-efc7-329d-b09b-16583867b653'"/>
      <xsl:map-entry key="'BNDG-G882'" select="'NORM-a389dfdd-55e7-354d-8b46-bc4178e6607e'"/>
      <xsl:map-entry key="'BNDG-G924'" select="'NORM-8a660689-e5ab-3121-855f-4eb6f6a59904'"/>
      <xsl:map-entry key="'BNDG-G948'" select="'NORM-4d67db30-9289-31fe-bc6d-e1ae609e1b88'"/>
      <xsl:map-entry key="'BNDG-G993'" select="'NORM-84af7d18-d82f-33f7-95fd-82a8d1aa4afb'"/>
      <xsl:map-entry key="'BNDG-H139'" select="'NORM-ed2b9bf3-dc19-3a52-97dd-c9ef5c537bbf'"/>
      <xsl:map-entry key="'BNDG-H219'" select="'NORM-10a62af8-9d42-33e0-841e-23bbc72a34ae'"/>
      <xsl:map-entry key="'BNDG-H466'" select="'NORM-91c6c885-a528-3bfd-a334-b50432c58002'"/>
      <xsl:map-entry key="'BNDG-H505'" select="'NORM-d70dfd28-7acd-3f71-ae4e-0afbea7c0221'"/>
      <xsl:map-entry key="'BNDG-H581'" select="'NORM-9ce238df-e084-37bb-a1ea-54ac9a9d8891'"/>
      <xsl:map-entry key="'BNDG-H589'" select="'NORM-79994a64-a10b-3971-802d-9aeab020f318'"/>
      <xsl:map-entry key="'BNDG-H682'" select="'NORM-14ea38fd-da69-3dfa-9a93-3f4fb8197771'"/>
      <xsl:map-entry key="'BNDG-H783'" select="'NORM-52040756-2804-39f7-8c16-cea264cfe0c1'"/>
      <xsl:map-entry key="'BNDG-H788'" select="'NORM-4b018cb6-5b1e-3df9-af8c-110a5e269462'"/>
      <xsl:map-entry key="'BNDG-H819'" select="'NORM-07a63824-abae-3aa9-8c89-068c2c2fe1ec'"/>
      <xsl:map-entry key="'BNDG-H857'" select="'NORM-920fc72e-3219-3d9f-a9ac-c5734d33a4c5'"/>
      <xsl:map-entry key="'BNDG-H873'" select="'NORM-eed0e981-4edb-3525-aae9-009b2766563e'"/>
      <xsl:map-entry key="'BNDG-H918'" select="'NORM-937781c3-c676-3de5-a827-f4a2f065e75d'"/>
      <xsl:map-entry key="'BNDG-H963'" select="'NORM-eca6431d-2a13-391a-9baf-c29a4fc8674f'"/>
      <xsl:map-entry key="'BNDG-K129'" select="'NORM-48bc490e-2b76-3357-9356-93ef2faa4736'"/>
      <xsl:map-entry key="'BNDG-K257'" select="'NORM-4e6d4e42-cd51-32f7-8cd8-34cbd24020e8'"/>
      <xsl:map-entry key="'BNDG-K311'" select="'NORM-6bd0efa4-831f-3371-bd8a-922157a5f2ad'"/>
      <xsl:map-entry key="'BNDG-K350'" select="'NORM-59536122-71b7-3941-98e4-87162e3ab5c4'"/>
      <xsl:map-entry key="'BNDG-K366'" select="'NORM-9161038e-bbfd-393b-9130-2b419d9a4c08'"/>
      <xsl:map-entry key="'BNDG-K408'" select="'NORM-b90289b9-01f1-35aa-a0d4-ea1d7be792a4'"/>
      <xsl:map-entry key="'BNDG-K594'" select="'NORM-7aab2d50-20a9-3fc9-b230-1b750cddc14f'"/>
      <xsl:map-entry key="'BNDG-K691'" select="'NORM-b38deb6e-388e-346b-9cba-2f6e7415380a'"/>
      <xsl:map-entry key="'BNDG-K706'" select="'NORM-11d8c963-a2a6-3eec-a458-16cacca89c89'"/>
      <xsl:map-entry key="'BNDG-K707'" select="'NORM-98a49fd0-1395-3c33-929d-acbb2585b8bd'"/>
      <xsl:map-entry key="'BNDG-K755'" select="'NORM-902f17f1-8685-3112-ad98-13690fd19983'"/>
      <xsl:map-entry key="'BNDG-K763'" select="'NORM-57b5dc4e-01fd-3150-a407-0e9fe2c104d9'"/>
      <xsl:map-entry key="'BNDG-K767'" select="'NORM-4da2b9b3-724d-31a9-ae63-4fa08c3e2fcc'"/>
      <xsl:map-entry key="'BNDG-K927'" select="'NORM-f65bb4b9-712c-3c42-aabe-d791bde3913a'"/>
      <xsl:map-entry key="'BNDG-M246'" select="'NORM-27291f17-78e6-3e48-bed2-e45d0ca177f8'"/>
      <xsl:map-entry key="'BNDG-M301'" select="'NORM-6289b6cd-6c1c-3a6e-b265-47c7c20913b5'"/>
      <xsl:map-entry key="'BNDG-M340'" select="'NORM-e999291b-5974-3519-bea5-6368448ffb5c'"/>
      <xsl:map-entry key="'BNDG-M354'" select="'NORM-8de04b68-b1d0-3803-a21d-2bf9671a0512'"/>
      <xsl:map-entry key="'BNDG-M383'" select="'NORM-49cc3d7b-1287-3b14-8c52-5475851261c5'"/>
      <xsl:map-entry key="'BNDG-M398'" select="'NORM-dd7dbb28-9778-345e-8cbd-ba64a6c75d54'"/>
      <xsl:map-entry key="'BNDG-M426'" select="'NORM-a5874231-7c6b-3039-b472-f2bb854f6cc7'"/>
      <xsl:map-entry key="'BNDG-M530'" select="'NORM-82bbbacf-3492-3f74-87d1-8c6dfdacd131'"/>
      <xsl:map-entry key="'BNDG-M760'" select="'NORM-15d0ffbf-2df1-38b9-9a3a-ad51304eef6c'"/>
      <xsl:map-entry key="'BNDG-M829'" select="'NORM-12c35a54-1e33-312b-b271-0ae23b084ae4'"/>
      <xsl:map-entry key="'BNDG-M837'" select="'NORM-1ffc6ef8-ebbc-3385-b5a1-0e173a831845'"/>
      <xsl:map-entry key="'BNDG-M878'" select="'NORM-ebcb5974-b066-3435-bb8e-efbd4716df6b'"/>
      <xsl:map-entry key="'BNDG-N174'" select="'NORM-5271c031-82cb-342a-85a1-811d827c9cfe'"/>
      <xsl:map-entry key="'BNDG-N271'" select="'NORM-68230ccf-dc08-3ccf-bdf0-6e558ba29b48'"/>
      <xsl:map-entry key="'BNDG-N291'" select="'NORM-1a8d45b0-6036-3668-bc46-3cdd100b265a'"/>
      <xsl:map-entry key="'BNDG-N625'" select="'NORM-4f8a246b-c8ce-3361-b027-c7b310d420b2'"/>
      <xsl:map-entry key="'BNDG-X111'" select="'NORM-7c4a57fe-56b8-38ec-880a-025a0cb2a039'"/>
      <xsl:map-entry key="'BNDG-X120'" select="'NORM-05a191a8-f540-3d6b-af2b-479350cb86de'"/>
      <xsl:map-entry key="'BNDG-X135'" select="'NORM-b6513b61-5e50-3250-8327-313f9dd9248b'"/>
      <xsl:map-entry key="'BNDG-X152'" select="'NORM-d8b9b25c-ca76-36f8-9d47-13602df14b3b'"/>
      <xsl:map-entry key="'BNDG-X160'" select="'NORM-62d0576f-0b94-3874-a697-939f968334c6'"/>
      <xsl:map-entry key="'BNDG-X256'" select="'NORM-03d2d019-e7c3-3aa5-b9f6-e4ca4e4ce8da'"/>
      <xsl:map-entry key="'BNDG-X301'" select="'NORM-f3a686cc-9ae0-39ba-9942-a1711bee72cd'"/>
      <xsl:map-entry key="'BNDG-X370'" select="'NORM-38b0b16c-8035-3999-9850-fad0c7708e7f'"/>
      <xsl:map-entry key="'BNDG-X371'" select="'NORM-385f8116-3a04-3d30-90be-b0e17d0323ee'"/>
      <xsl:map-entry key="'BNDG-X403'" select="'NORM-71e33fba-4c53-33e8-a185-603350f72963'"/>
      <xsl:map-entry key="'BNDG-X411'" select="'NORM-718b2806-f17f-3bf7-80b9-7de56ed3d970'"/>
      <xsl:map-entry key="'BNDG-X434'" select="'NORM-47d4a83a-7a27-30da-a1d8-6d10e50a0af2'"/>
      <xsl:map-entry key="'BNDG-X462'" select="'NORM-0932d90f-1832-3db2-8bfa-104b5e9d2d83'"/>
      <xsl:map-entry key="'BNDG-X463'" select="'NORM-0194ac06-f607-3a66-813f-479f96873174'"/>
      <xsl:map-entry key="'BNDG-X497'" select="'NORM-d193bf3d-9c37-3a26-93f7-c45953c1f142'"/>
      <xsl:map-entry key="'BNDG-X507'" select="'NORM-bc08c26c-5cc5-31af-8eec-6bb0ac2cd9b3'"/>
      <xsl:map-entry key="'BNDG-X508'" select="'NORM-7895429f-043a-38e0-be33-5f66ce0b7db5'"/>
      <xsl:map-entry key="'BNDG-X514'" select="'NORM-8bdbb752-fdba-35ed-95b6-399ee594fddd'"/>
      <xsl:map-entry key="'BNDG-X558'" select="'NORM-59462a57-b9e1-3a8f-9f77-f8feb718e7f8'"/>
      <xsl:map-entry key="'BNDG-X605'" select="'NORM-9f2b8a45-13c1-3f39-9b3a-98dcc1a4d85d'"/>
      <xsl:map-entry key="'BNDG-X628'" select="'NORM-ae412238-c8b8-322c-a44e-27bfdff229c9'"/>
      <xsl:map-entry key="'BNDG-X642'" select="'NORM-a3056f4f-99f8-3691-9d33-1b56bd77ef6c'"/>
      <xsl:map-entry key="'BNDG-X658'" select="'NORM-7b28a4c4-3a01-3627-8b1a-79bce7c94d79'"/>
      <xsl:map-entry key="'BNDG-X671'" select="'NORM-c329900e-60db-3079-8de1-f7f33f18f56b'"/>
      <xsl:map-entry key="'BNDG-X699'" select="'NORM-1a8294ea-f4a1-3b73-85a2-5c9c29e472df'"/>
      <xsl:map-entry key="'BNDG-X717'" select="'NORM-4471bc16-5906-335b-a8bf-de6f25409f83'"/>
      <xsl:map-entry key="'BNDG-X767'" select="'NORM-b57a886c-0ec9-3625-b314-df42108eefb2'"/>
      <xsl:map-entry key="'BNDG-X774'" select="'NORM-54b7d37c-ad43-3e69-8094-efa754004f57'"/>
      <xsl:map-entry key="'BNDG-X778'" select="'NORM-f51ffbd5-334f-37c7-81aa-73164c28a2c3'"/>
      <xsl:map-entry key="'BNDG-X831'" select="'NORM-b1c58fd8-8644-3d5e-8571-22d0a2756087'"/>
      <xsl:map-entry key="'BNDG-X839'" select="'NORM-a32d2b20-f912-344d-9a45-959f870aea50'"/>
      <xsl:map-entry key="'BNDG-X876'" select="'NORM-ad6d643c-f601-3442-bddb-b90cfb17fac7'"/>
      <xsl:map-entry key="'BNDG-X886'" select="'NORM-81477f76-8c5b-3070-a0c9-019a19d6df73'"/>
      <xsl:map-entry key="'BNDG-X972'" select="'NORM-0d634034-dcf5-3b8e-8d8f-a2cf3d8bff19'"/>
      <xsl:map-entry key="'BNDG-X974'" select="'NORM-6d42bbdc-ddd9-38dd-a8ee-8f8c73e92f3a'"/>
      <xsl:map-entry key="'BNDG-X980'" select="'NORM-cd8796dd-5067-366f-9a68-c651c2a9b47f'"/>
      <xsl:map-entry key="'BNDG-X986'" select="'NORM-acf21b42-a2ab-3aee-b86e-506c8b1dd58a'"/>
      <xsl:map-entry key="'BNDG-X990'" select="'NORM-ca4cd5ac-19e8-30f3-bd9c-2e182b57a8f7'"/>

      <xsl:map-entry key="'SCRP-X710'" select="'NORM-569f8863-7092-3880-a316-336864b2347f'"/>
      <xsl:map-entry key="'SCRP-X966'" select="'NORM-c5424973-f63b-3914-a7a3-faa45fda495b'"/>
      <xsl:map-entry key="'SCRP-X977'" select="'NORM-ded4cb2f-f416-3787-a9cd-9dadb12fc695'"/>
      <xsl:map-entry key="'SCRP-X473'" select="'NORM-f944f51f-6b40-3d55-8fe9-ffd785479261'"/>
      <xsl:map-entry key="'SCRP-X364'" select="'NORM-403bac9b-5f10-332d-af4e-07b9d8f234fa'"/>
      <xsl:map-entry key="'SCRP-X207'" select="'NORM-4139b0e5-08e2-3c30-80c3-83ab2a7518a1'"/>
      <xsl:map-entry key="'SCRP-X591'" select="'NORM-ff9f9335-560f-379e-a4f1-a0c8f9d3caa7'"/>
      <xsl:map-entry key="'SCRP-X952'" select="'NORM-0cf8c750-5708-32ad-9508-c80e6ba72a3b'"/>
      <xsl:map-entry key="'SCRP-X138'" select="'NORM-707e9d27-699c-3e3d-aab1-e285673d91c4'"/>
      <xsl:map-entry key="'SCRP-X100'" select="'NORM-6c957d21-516e-36fc-bd59-cf7494123207'"/>
      <xsl:map-entry key="'SCRP-X747'" select="'NORM-70253812-c682-3607-b9c0-9136502138fc'"/>
      <xsl:map-entry key="'SCRP-X985'" select="'NORM-b58d48a1-f4a4-38bf-820c-cbb2ec05bbe9'"/>
      <xsl:map-entry key="'SCRP-X201'" select="'NORM-bf0c1fbf-64f8-3cbd-b1a2-d3d4dcd6e2b7'"/>
      <xsl:map-entry key="'SCRP-X831'" select="'NORM-33a7cd6d-c463-3453-9a4a-00200df22a3e'"/>
      <xsl:map-entry key="'SCRP-X881'" select="'NORM-5ab38dab-efc3-3b27-bcec-c6d809655b55'"/>
      <xsl:map-entry key="'SCRP-X769'" select="'NORM-733f5435-c07e-38e8-bd95-626fb4b00d8e'"/>
      <xsl:map-entry key="'SCRP-X882'" select="'NORM-76587de5-dfe9-3385-845f-dd98a511b042'"/>
      <xsl:map-entry key="'SCRP-X892'" select="'NORM-2286ab03-f32d-3ee7-b2a6-e6ef5aa37f46'"/>
      <xsl:map-entry key="'SCRP-X383'" select="'NORM-4c66edec-9bca-330d-bec3-e804461877bd'"/>
      <xsl:map-entry key="'SCRP-X477'" select="'NORM-6b1516f7-7c1b-3808-a919-52e52c12a59a'"/>
      <xsl:map-entry key="'SCRP-X140'" select="'NORM-6325c732-12de-3d37-ba56-fef8ced49556'"/>
      <xsl:map-entry key="'SCRP-X796'" select="'NORM-74fb135e-4657-3379-8646-bcdf909b296e'"/>
      <xsl:map-entry key="'SCRP-X294'" select="'NORM-10f455be-acf9-3493-97d3-c024e5ae16d5'"/>
      <xsl:map-entry key="'SCRP-X942'" select="'NORM-f8cc16e2-95ee-37e0-a04b-dddb92f7fabe'"/>
      <xsl:map-entry key="'SCRP-X225'" select="'NORM-6efb292c-5fe8-3302-89f4-11fd1bff0da2'"/>
      <xsl:map-entry key="'SCRP-X997'" select="'NORM-607cbde8-6356-3502-bc56-6cc970e2a985'"/>
      <xsl:map-entry key="'SCRP-X599'" select="'NORM-1b833b9b-323d-3d22-accf-7e197d20da64'"/>
      <xsl:map-entry key="'SCRP-X863'" select="'NORM-d47ec2e8-cbc5-3861-8ca9-5bbb1b677753'"/>
      <xsl:map-entry key="'SCRP-X969'" select="'NORM-74141f98-83ed-3626-b672-a1fa30929853'"/>
      <xsl:map-entry key="'SCRP-X937'" select="'NORM-2c113c74-ed05-3bbd-b66a-f609a5a7c2f7'"/>
      <xsl:map-entry key="'SCRP-X219'" select="'NORM-08453ef2-5455-3801-bee5-7fe477a6fa43'"/>
      <xsl:map-entry key="'SCRP-X617'" select="'NORM-d1414cfd-8f82-3579-b4d5-7ebaecb13842'"/>
      <xsl:map-entry key="'SCRP-X259'" select="'NORM-f4e2e03e-f761-317e-b808-27e6d090ca07'"/>
      <xsl:map-entry key="'SCRP-X269'" select="'NORM-8383ee7b-3f2e-33aa-9cad-8992c43e415a'"/>
      <xsl:map-entry key="'SCRP-X448'" select="'NORM-4df73ccc-af29-31e8-bf4e-c3e92804dc1c'"/>
      <xsl:map-entry key="'SCRP-X484'" select="'NORM-f044d9ec-ff58-3e59-8222-f389583c3c84'"/>
      <xsl:map-entry key="'SCRP-X196'" select="'NORM-e3117827-34a8-380c-8c1e-ce9686d80613'"/>
      <xsl:map-entry key="'SCRP-X168'" select="'NORM-852ab7b7-fd0b-3336-b4b4-285c96a7003b'"/>
      <xsl:map-entry key="'SCRP-X811'" select="'NORM-faaf77a7-f999-33f7-b4c3-145120d131e1'"/>
      <xsl:map-entry key="'SCRP-X580'" select="'NORM-c5ad44f2-c0ac-37c7-9cbc-695e2d994c40'"/>
      <xsl:map-entry key="'SCRP-X693'" select="'NORM-ce1aafcc-120d-3261-bb3e-ead279940e06'"/>
      <xsl:map-entry key="'SCRP-X561'" select="'NORM-16a58110-4bf8-36d3-9211-2c9876055ee3'"/>
      <xsl:map-entry key="'SCRP-X978'" select="'NORM-dad63614-5630-3bc9-ab8f-a359bb4f8997'"/>
      <xsl:map-entry key="'SCRP-X845'" select="'NORM-ea43c3ef-6b06-368f-a8d4-cabfdaeee0f3'"/>
      <xsl:map-entry key="'SCRP-X367'" select="'NORM-c237bb61-0d39-3a33-b644-4161daa627fd'"/>
      <xsl:map-entry key="'SCRP-X872'" select="'NORM-e8702ffb-d6c2-36be-84bb-189018868d0b'"/>
      <xsl:map-entry key="'SCRP-X400'" select="'NORM-7fade14d-da4e-30be-bc3e-b11442eb4396'"/>
      <xsl:map-entry key="'SCRP-X628'" select="'NORM-be436ae1-2e74-3ae9-93bc-c3b917de24f1'"/>
      <xsl:map-entry key="'SCRP-X730'" select="'NORM-042a2e21-18d6-36d1-9a23-7827909b21f4'"/>
      <xsl:map-entry key="'SCRP-X702'" select="'NORM-08c2cebe-1c52-38d7-b2f7-015226f485a3'"/>
      <xsl:map-entry key="'SCRP-X839'" select="'NORM-4438095f-3533-35f4-abbc-0ceb55574ced'"/>
      <xsl:map-entry key="'SCRP-X263'" select="'NORM-9b430dd3-2b45-3b4c-bf0d-bb130b57cdc5'"/>
      <xsl:map-entry key="'SCRP-X101'" select="'NORM-7901bf7a-abe0-3605-aa75-51937ea6f7fc'"/>
      <xsl:map-entry key="'SCRP-X943'" select="'NORM-7ccb2c61-d161-39de-b59e-5599e9bd49d2'"/>
      <xsl:map-entry key="'SCRP-X885'" select="'NORM-3bff9855-ba47-3143-ad80-0e9dc528c488'"/>
      <xsl:map-entry key="'SCRP-X935'" select="'NORM-a883baa9-ff82-31d3-83ce-36935a84c077'"/>
      <xsl:map-entry key="'SCRP-X826'" select="'NORM-bbe25547-e59f-3b18-b86c-17c44623c174'"/>
      <xsl:map-entry key="'SCRP-X922'" select="'NORM-552150c9-15d6-3dfb-91a0-b0eada695b5a'"/>
      <xsl:map-entry key="'SCRP-X608'" select="'NORM-8e5bd415-aaa5-385f-8b66-a35b8242b47a'"/>
      <xsl:map-entry key="'SCRP-X825'" select="'NORM-d1558cf7-d643-37bc-b211-a7480caf92e1'"/>
      <xsl:map-entry key="'SCRP-X645'" select="'NORM-78c14069-f3b9-3efc-9a33-8c1cf1283aa6'"/>
      <xsl:map-entry key="'SCRP-X549'" select="'NORM-04538058-9742-30c0-8e0b-3447935cfdc8'"/>
      <xsl:map-entry key="'SCRP-X576'" select="'NORM-9555e99c-cda3-34ad-b1c1-aabd69b57370'"/>
      <xsl:map-entry key="'SCRP-X758'" select="'NORM-2682e071-3e7b-376d-928b-2739f8c93b51'"/>
      <xsl:map-entry key="'SCRP-X856'" select="'NORM-eb212fcc-e06c-31bb-82cd-516039ee68a1'"/>
      <xsl:map-entry key="'SCRP-X648'" select="'NORM-90547742-707a-35c3-99ef-d1530167e0c6'"/>
      <xsl:map-entry key="'SCRP-X698'" select="'NORM-6af4cc6a-0d18-3b51-aa30-675853a19905'"/>
      <xsl:map-entry key="'SCRP-X341'" select="'NORM-e448fdf1-ba6d-3fec-ac90-1c3e00123769'"/>
      <xsl:map-entry key="'SCRP-X627'" select="'NORM-df1973b7-3bcf-3642-93ba-fec2ca467009'"/>
      <xsl:map-entry key="'SCRP-X255'" select="'NORM-5300aec7-75be-3215-a9b7-e9a50801227d'"/>
      <xsl:map-entry key="'SCRP-X786'" select="'NORM-af1295ac-8845-370a-8274-d1f121952a93'"/>
      <xsl:map-entry key="'SCRP-X232'" select="'NORM-f7235694-4ee8-35db-88a4-310554c4f608'"/>
      <xsl:map-entry key="'SCRP-X715'" select="'NORM-3e1e62ae-c0d6-353e-9436-21c0ec273e89'"/>
      <xsl:map-entry key="'SCRP-X672'" select="'NORM-b8b327ae-59c2-3b3a-ae0a-2419fb03e89f'"/>
      <xsl:map-entry key="'SCRP-X489'" select="'NORM-f76678f1-cdc9-373c-9c42-e9b5d33dc2f6'"/>
      <xsl:map-entry key="'SCRP-X631'" select="'NORM-02a4df8a-35fa-3297-abc1-b78f42eae085'"/>
      <xsl:map-entry key="'SCRP-X859'" select="'NORM-14010585-e340-36c9-9492-27ab3951e047'"/>
      <xsl:map-entry key="'SCRP-X248'" select="'NORM-6ee5bfaa-8699-3dcb-8877-ebe31714f045'"/>
      <xsl:map-entry key="'SCRP-X610'" select="'NORM-cad97ed2-15ed-3874-83f5-bc1cdcb0c637'"/>
      <xsl:map-entry key="'SCRP-X483'" select="'NORM-6b4e3445-f051-3ee7-bb4c-bfc39e345dff'"/>
      <xsl:map-entry key="'SCRP-X637'" select="'NORM-c4855b46-e42d-31f0-a181-93c10d49c330'"/>
      <xsl:map-entry key="'SCRP-X423'" select="'NORM-a4ef002e-f531-3b14-8ecb-79d1033424dc'"/>
      <xsl:map-entry key="'SCRP-X553'" select="'NORM-7ccd2c64-951f-3e7d-b58e-65420e529fd8'"/>
      <xsl:map-entry key="'SCRP-X565'" select="'NORM-c63874c6-5401-3be8-9fe3-e9e058c547a4'"/>
      <xsl:map-entry key="'SCRP-X357'" select="'NORM-3ef3987f-7b6f-35d3-8723-1465fb145105'"/>
      <xsl:map-entry key="'SCRP-X824'" select="'NORM-a95ce055-a959-3bb6-9a0d-55702b9192d3'"/>
      <xsl:map-entry key="'SCRP-X950'" select="'NORM-1b80beb3-734e-3cac-853c-5b1237387d98'"/>
      <xsl:map-entry key="'SCRP-X128'" select="'NORM-9779428a-fad2-3c2c-923c-79757ee6e56d'"/>
      <xsl:map-entry key="'SCRP-X334'" select="'NORM-8e44143f-cc0b-3ccf-8a0d-9f4e04c7107f'"/>
      <xsl:map-entry key="'SCRP-X744'" select="'NORM-fa77d03e-5e6d-3d33-bacb-b7fc00971fe9'"/>
      <xsl:map-entry key="'SCRP-X788'" select="'NORM-30311178-4bca-3ee4-b2d9-91e1981ff5ad'"/>
      <xsl:map-entry key="'SCRP-X980'" select="'NORM-b7bc29b9-b4a7-36c8-ba98-c07090e74d75'"/>
      <xsl:map-entry key="'SCRP-X867'" select="'NORM-09b9ac8e-4d03-3116-9caa-531415c5f1cf'"/>
      <xsl:map-entry key="'SCRP-X284'" select="'NORM-a5b0ff27-b147-339b-bf23-2a3227c71560'"/>
      <xsl:map-entry key="'SCRP-E778'" select="'NORM-16528e70-5377-380a-b965-886a5d766f18'"/>
      <xsl:map-entry key="'SCRP-E405'" select="'NORM-be4fe60e-4233-38f1-be6f-00d27f528406'"/>
      <xsl:map-entry key="'SCRP-E859'" select="'NORM-d0bf2815-54cf-3b0f-9118-85884a4beeea'"/>
      <xsl:map-entry key="'SCRP-E815'" select="'NORM-12cde6ea-b6e5-35b9-a695-e434b8b68110'"/>
      <xsl:map-entry key="'SCRP-E133'" select="'NORM-b0f59dc1-93ee-3876-8a26-4c2545577e5e'"/>
      <xsl:map-entry key="'SCRP-A475'" select="'NORM-638ffd41-c121-3664-a6e3-0c23e10392d3'"/>
      <xsl:map-entry key="'SCRP-A755'" select="'NORM-b220d36a-baba-371a-8b59-7f6829e9bde7'"/>
      <xsl:map-entry key="'SCRP-A384'" select="'NORM-db280956-53a0-3a8b-a79b-48e951d6b9c4'"/>
      <xsl:map-entry key="'SCRP-A219'" select="'NORM-69a1980d-bfbb-3dcd-b5eb-6637f13616c3'"/>
      <xsl:map-entry key="'SCRP-A372'" select="'NORM-f75ec95c-25fc-320f-8846-5d266b633514'"/>
      <xsl:map-entry key="'SCRP-A576'" select="'NORM-f5ad96d4-7dde-3e20-be67-f2726a252436'"/>
      <xsl:map-entry key="'SCRP-A338'" select="'NORM-28dfa3ec-1b18-3671-b40e-d2f98b67e4ba'"/>
      <xsl:map-entry key="'SCRP-D266'" select="'NORM-025e7b12-b321-371d-b917-e031eb6b6b76'"/>
      <xsl:map-entry key="'SCRP-D823'" select="'NORM-8c04f308-680f-35e2-99f3-0e58e5c136b0'"/>
      <xsl:map-entry key="'SCRP-D338'" select="'NORM-de26363d-ceeb-363d-bc2c-0e9f3fbc4f15'"/>
      <xsl:map-entry key="'SCRP-D676'" select="'NORM-56168dda-c4c5-360f-ba81-e99966ed5801'"/>
      <xsl:map-entry key="'SCRP-B155'" select="'NORM-4c71bcf9-3930-32f4-a889-ecfdd2d1324d'"/>
      <xsl:map-entry key="'SCRP-B884'" select="'NORM-bb7b39f5-d14f-3a51-b509-4d072e005bba'"/>
      <xsl:map-entry key="'SCRP-B387'" select="'NORM-d7cf0119-bc59-332d-a43a-3ec275e4122f'"/>
      <xsl:map-entry key="'SCRP-C439'" select="'NORM-b55a4e82-8997-3c4b-be28-1d4c79182840'"/>
      <xsl:map-entry key="'SCRP-C245'" select="'NORM-d9168c73-100e-3ec3-af2e-44f3a413ce29'"/>
      <xsl:map-entry key="'SCRP-C792'" select="'NORM-5f65aa55-5aae-3c96-916c-a7872706066f'"/>

      <xsl:map-entry key="'WRLA-A683'" select="'NORM-9de76710-d1b8-3b89-82bd-4fb7ede33f2c'"/>
      <xsl:map-entry key="'WRLA-A506'" select="'NORM-8eece73b-e540-31b6-a6d8-59fc2caecb6b'"/>
      <xsl:map-entry key="'WRLA-A253'" select="'NORM-bdba47b1-fe40-3e6e-9cdc-d954815f1966'"/>
      <xsl:map-entry key="'WRLA-A496'" select="'NORM-54a7f229-0905-3409-8feb-f626478f1533'"/>
      <xsl:map-entry key="'WRLA-A467'" select="'NORM-6db51376-070e-326f-8266-d353fec7f550'"/>
      <xsl:map-entry key="'WRLA-A100'" select="'NORM-8dfc18f8-8304-3165-86e3-f647881042c7'"/>
      <xsl:map-entry key="'WRLA-A229'" select="'NORM-1392beb1-ed03-31be-85db-931ee452ef80'"/>
      <xsl:map-entry key="'WRLA-A129'" select="'NORM-946c1536-ad9e-33cf-a645-eee64f41f4fe'"/>
      <xsl:map-entry key="'WRLA-A538'" select="'NORM-de63a1fc-2fe4-3720-ad75-95e06f05f8ef'"/>
      <xsl:map-entry key="'WRLA-A747'" select="'NORM-5500f257-a524-3fc6-af2f-ccc8cbec534b'"/>
      <xsl:map-entry key="'WRLA-A968'" select="'NORM-c1ec682a-d812-3d25-9e58-81c265d8a192'"/>
      <xsl:map-entry key="'WRLA-A816'" select="'NORM-b104c080-3412-39d8-8b05-fb65d00ddfcd'"/>
      <xsl:map-entry key="'WRLA-A177'" select="'NORM-1e774ace-1537-3672-a48e-a7b6681e4091'"/>
      <xsl:map-entry key="'WRLA-A512'" select="'NORM-159ba151-6d9c-38eb-8590-1881de893177'"/>
      <xsl:map-entry key="'WRLA-A349'" select="'NORM-122db947-5ff2-353a-9243-4af3532deb37'"/>
      <xsl:map-entry key="'WRLA-A392'" select="'NORM-3b8c2c21-dde9-3e53-afef-dceb06c6c293'"/>
      <xsl:map-entry key="'WRLA-A243'" select="'NORM-46abf975-272f-3a5c-96bd-083e847dab18'"/>
      <xsl:map-entry key="'WRLA-A859'" select="'NORM-0a8962f7-9f62-3775-8900-cdf5f8d6d1f4'"/>
      <xsl:map-entry key="'WRLA-A469'" select="'NORM-023eedc2-61c8-3da7-80ff-d9e84678c1a3'"/>
      <xsl:map-entry key="'WRLA-A842'" select="'NORM-55a01872-2229-32b9-8db9-d802226404f8'"/>
      <xsl:map-entry key="'WRLA-A659'" select="'NORM-0655cea1-87ed-3f6a-9e0a-19061bef53f3'"/>
      <xsl:map-entry key="'WRLA-A222'" select="'NORM-50a524b2-3a69-3cbf-a36e-91fb00457ee9'"/>
      <xsl:map-entry key="'WRLA-A523'" select="'NORM-df1231ae-28f7-3183-811b-c7bd212b2494'"/>
      <xsl:map-entry key="'WRLA-A317'" select="'NORM-2940c107-c697-383b-9762-770d63fb470a'"/>
      <xsl:map-entry key="'WRLA-A551'" select="'NORM-f2d19815-0500-3595-a111-1d416ab81f67'"/>
      <xsl:map-entry key="'WRLA-A133'" select="'NORM-3fa69ce1-fd13-380b-8a21-aa14fd1032cb'"/>
      <xsl:map-entry key="'WRLA-A104'" select="'NORM-e570142f-67cf-39a2-bcb9-fd840214125e'"/>
      <xsl:map-entry key="'WRLA-A890'" select="'NORM-6d729505-cdc8-3338-8ec4-854339b51531'"/>
      <xsl:map-entry key="'WRLA-A405'" select="'NORM-67913f1c-13d0-3827-89d8-61c5ab9b5f2f'"/>
      <xsl:map-entry key="'WRLA-A437'" select="'NORM-75456e15-273a-3712-b237-24285a77baa8'"/>
      <xsl:map-entry key="'WRLA-A449'" select="'NORM-747b78eb-8bc7-3723-b3b4-339d5e60a2db'"/>
      <xsl:map-entry key="'WRLA-A353'" select="'NORM-83763238-765b-3543-855e-0b2a7761853e'"/>
      <xsl:map-entry key="'WRLA-A757'" select="'NORM-4220aac4-18d5-37a0-816d-ac1991004f3b'"/>
      <xsl:map-entry key="'WRLA-A554'" select="'NORM-8256a43e-376f-3ae0-a948-72949520e781'"/>
      <xsl:map-entry key="'WRLA-A869'" select="'NORM-99abf334-cbf7-3c90-963b-907d6daf44ed'"/>
      <xsl:map-entry key="'WRLA-A851'" select="'NORM-9eda9f87-deb5-3bb2-a9ab-dfb280e977b5'"/>
      <xsl:map-entry key="'WRLA-A207'" select="'NORM-8d1db6ae-02bc-37cb-8406-8e088386bd78'"/>
      <xsl:map-entry key="'WRLA-A181'" select="'NORM-45b87784-2915-3223-92c3-44a017a77b4c'"/>
      <xsl:map-entry key="'WRLA-A928'" select="'NORM-27dd6ada-731b-3dd2-b9aa-8f06d77fbc7d'"/>
      <xsl:map-entry key="'WRLA-A307'" select="'NORM-a80e6fb2-31f2-341a-b218-97f83322e2f1'"/>
      <xsl:map-entry key="'WRLA-A149'" select="'NORM-8f09635d-c3f0-3632-96b1-fdfdb3b52cf2'"/>
      <xsl:map-entry key="'WRLA-A848'" select="'NORM-88fa7567-4dac-302e-864b-7a7406235272'"/>
      <xsl:map-entry key="'WRLA-A375'" select="'NORM-24e399b2-e182-30d9-998b-8f65ef5279c7'"/>
      <xsl:map-entry key="'WRLA-A352'" select="'NORM-68dced5e-fa21-349f-8385-5933d51a41f3'"/>
      <xsl:map-entry key="'WRLA-A640'" select="'NORM-dfbf4d45-6e67-3048-a7e1-efaeab129078'"/>
      <xsl:map-entry key="'WRLA-A940'" select="'NORM-561305b8-14a2-3039-b776-6dbef3366818'"/>
      <xsl:map-entry key="'WRLA-A273'" select="'NORM-0ea422d4-5ff1-34c3-92ea-766653bb94f7'"/>
      <xsl:map-entry key="'WRLA-A139'" select="'NORM-347d5341-0afa-3c6a-98fe-18fbb740f70c'"/>
      <xsl:map-entry key="'WRLA-A201'" select="'NORM-8b741dde-6d35-32ef-92ec-772bd847273a'"/>
      <xsl:map-entry key="'WRLA-A268'" select="'NORM-f8e51184-24c4-3e2a-b221-b319d326ebb7'"/>
      <xsl:map-entry key="'WRLA-A705'" select="'NORM-b5eb7b18-5286-3d02-904a-352ed52fc6b1'"/>
      <xsl:map-entry key="'WRLA-A584'" select="'NORM-873ec789-ed3b-36c9-853a-bd703645baca'"/>
      <xsl:map-entry key="'WRLA-A977'" select="'NORM-d7532280-ac90-397e-82ac-0cb9667a6056'"/>
      <xsl:map-entry key="'WRLA-A497'" select="'NORM-078d81ce-ba96-3b76-af1c-3120bb93106a'"/>
      <xsl:map-entry key="'WRLA-A845'" select="'NORM-b30215bf-d53c-3306-8b72-e28fe35ce3ff'"/>
      <xsl:map-entry key="'WRLA-A399'" select="'NORM-385d8ee9-8c6f-3c4f-b81a-9f0992fb59e8'"/>
      <xsl:map-entry key="'WRLA-A409'" select="'NORM-56545203-8e8c-3405-a92f-a989ebb9ab36'"/>
      <xsl:map-entry key="'WRLA-A892'" select="'NORM-c0f3303e-bc16-3ac9-b9fd-85982c937e89'"/>
      <xsl:map-entry key="'WRLA-A966'" select="'NORM-72305479-1dac-38d2-af84-a2454f800ad6'"/>
      <xsl:map-entry key="'WRLA-A517'" select="'NORM-fe39c094-d957-35fd-a496-ae709663bbd2'"/>
      <xsl:map-entry key="'WRLA-A326'" select="'NORM-55e8144e-bdbc-3974-98b1-6d278b214a3d'"/>
      <xsl:map-entry key="'WRLA-A960'" select="'NORM-8826133d-eff0-3fe4-8e89-9bd5d4f823fa'"/>
      <xsl:map-entry key="'WRLA-A214'" select="'NORM-27f56ece-1253-3bee-9cc0-693a033c23cf'"/>
      <xsl:map-entry key="'WRLA-A689'" select="'NORM-18f36d97-b735-37a9-b314-a1b29321907b'"/>
      <xsl:map-entry key="'WRLA-A482'" select="'NORM-1b377be8-0762-371b-ac60-d359dfe5938f'"/>
      <xsl:map-entry key="'WRLA-A669'" select="'NORM-99726544-917a-3407-b3ff-a6ec81b94336'"/>
      <xsl:map-entry key="'WRLA-A764'" select="'NORM-bc27f172-44f4-35fa-847c-ae17150b3c3a'"/>
      <xsl:map-entry key="'WRLA-A773'" select="'NORM-940fd554-721f-3875-b0e5-d4fac072a8f4'"/>
      <xsl:map-entry key="'WRLA-A638'" select="'NORM-806de216-9758-320a-b9d3-968cb1cff2ea'"/>
      <xsl:map-entry key="'WRLA-A921'" select="'NORM-4be8a03d-453a-3fd4-9388-994f805ad953'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:template name="writeReferences">
    <xsl:param name="notation"/>
    <xsl:variable name="normReference" select="$writeReferencesMap($notation)"/>
    <xsl:if test="$normReference">
      <xsl:attribute name="ref" select="concat($normdatenServer, $notation)"/>
      <xsl:attribute name="key" select="$normReference"/>
    </xsl:if>
  </xsl:template>

  <xsl:variable name="BNDG-5240-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'alla greca'" select="'BNDG-X699 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702'"/>
      <xsl:map-entry key="'Arabeskeneinband'" select="'BNDG-A239 BNDG-G607'"/>
      <xsl:map-entry key="'Barock-Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Barockeinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Barockeinband / moderner Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Barockeinband mit Einzel- und Rollenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-G525'"/>
      <xsl:map-entry key="'Bemalter Einband'" select="'BNDG-A239 BNDG-G948'"/>
      <xsl:map-entry key="'Beschläge'" select="'BNDG-M340'"/>
      <xsl:map-entry key="'besorgter spätgotischer Holzdeckeleinband, teilweise mit braunem Leder bezogen'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Beutelbuch'" select="'BNDG-X774 BNDG-A206 BNDG-B859 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-F142'"/>
      <xsl:map-entry key="'Beutelbuch?'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Blindprägeband'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G747'"/>
      <xsl:map-entry key="'Blindstempel-Einband'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882'"/>
      <xsl:map-entry key="'Blindstempeleinband'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882'"/>
      <xsl:map-entry key="'Blindstempeleinband, spätgotisch, auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Blindstempeleinband, spätmittelalterlich'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Blindstempeleinband, spätmittelalterlich, braun, auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Brauner Lederband'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Brauner Ledereinband auf Holzdeckeln, Byzantinische Technik'" select="'BNDG-X463 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Brauner Ledereinband auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Brauner Ledereinband auf Pappe in der Art eines alla greca-Bandes, aber nicht sehr gelungen'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-B118 BNDG-F468'"/>
      <xsl:map-entry key="'Brauner Wildledereinband (auf Pappe)'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Broschur'" select="'BNDG-X434 BNDG-A507 BNDG-B783'"/>
      <xsl:map-entry key="'Broschur (Heft 1)'" select="'BNDG-X434 BNDG-A507 BNDG-B783'"/>
      <xsl:map-entry key="'Buchblock, gebunden, im Schuber'" select="'BNDG-B859'"/>
      <xsl:map-entry key="'Buchblock, mittelalterlich gebunden, mit Rücken, ohne Decke, im neuzeitlichen Pappschuber'" select="'BNDG-A180'"/>
      <xsl:map-entry key="'Buchkassette'" select="'BNDG-X370 BNDG-A239'"/>
      <xsl:map-entry key="'Buchkasten'" select="'BNDG-X370 BNDG-A239'"/>
      <xsl:map-entry key="'Buntpapiereinband'" select="'BNDG-A239 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Byzantinischer Holzdeckeleinband'" select="'BNDG-X558 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Copert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Dunkelbrauner Ledereinband auf Holzdeckeln, Byzantinische Technik'" select="'BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-X463'"/>
      <xsl:map-entry key="'Einband, hell'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einband, hellbraun'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einband, modern'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einband, ottonisch'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einband, spätgotisch'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einband, spätgotischer'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einband mit Fragment'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Einschlagmappe'" select="'BNDG-A343'"/>
      <xsl:map-entry key="'Einzelstempeleinband'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882'"/>
      <xsl:map-entry key="'Erfurter Lielienschließen'" select="'BNDG-A239 BNDG-K706'"/>
      <xsl:map-entry key="'Erfurter Lilienschließen'" select="'BNDG-A239 BNDG-K706'"/>
      <xsl:map-entry key="'Flexible Pergamenteinband (ohne Unterlage)'" select="'BNDG-A507 BNDG-D864 BNDG-X876'"/>
      <xsl:map-entry key="'Flexibler Pergamenteinband'" select="'BNDG-X876 BNDG-A507'"/>
      <xsl:map-entry key="'Flexibler Pergamenteinband (ohne Unterlage)'" select="'BNDG-X876 BNDG-A507 BNDG-D864'"/>
      <xsl:map-entry key="'Flexibler Pergamenteinband (ohne Unterlage) mit umgebogenen Schutzkanten'" select="'BNDG-X876 BNDG-A507 BNDG-D864'"/>
      <xsl:map-entry key="'floraler Goldprägeeinband'" select="'BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G699'"/>
      <xsl:map-entry key="'Florimond-Badier-Einband'" select="'BNDG-A239 BNDG-G607'"/>
      <xsl:map-entry key="'Franzband'" select="'BNDG-X371 BNDG-A206 BNDG-B726 BNDG-F501 BNDG-E702 BNDG-D235'"/>
      <xsl:map-entry key="'frühgotischer Einband ohne Stempelschmuck'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-G117'"/>
      <xsl:map-entry key="'frühkarolingischer Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'frühneuzeitlicher Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'frühneuzeitlicher Einband mit Blindstempeln'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882'"/>
      <xsl:map-entry key="'frühneuzeitlicher Einband mit Blindstempeln und Streicheisenlinien'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'frühneuzeitlicher Einband mit Plattenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G124'"/>
      <xsl:map-entry key="'frühneuzeitlicher Einband mit Rollenstempeln, Einzelstempeln, Plattenstempeln und Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G882 BNDG-G437 BNDG-G124'"/>
      <xsl:map-entry key="'frühneuzeitlicher Einband mit Rollenstempeln, Einzelstempeln und Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'Frühneuzeitlicher Halblederband mit Blindpressung'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F682 BNDG-G747'"/>
      <xsl:map-entry key="'frühneuzeitlicher Halblederband mit Blindstempeln und Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F682 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'frühneuzeitlicher Lederband'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'frühneuzeitlicher Lederband mit Goldprägung'" select="'BNDG-A239 BNDG-E702 BNDG-G699 BNDG-F468'"/>
      <xsl:map-entry key="'frühneuzeitlicher Pergamentband'" select="'BNDG-X876 BNDG-A239'"/>
      <xsl:map-entry key="'frühneuzeitlicher Pergamentband mit Streicheisenlinien'" select="'BNDG-A239 BNDG-G437 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'frühneuzeitlicher Samtband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Fugger-Einband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-G607'"/>
      <xsl:map-entry key="'Ganzfranzband'" select="'BNDG-X301 BNDG-A206 BNDG-B726 BNDG-F571 BNDG-E702 BNDG-D235'"/>
      <xsl:map-entry key="'Ganzlederband'" select="'BNDG-A239 BNDG-E702 BNDG-F571'"/>
      <xsl:map-entry key="'Ganzleinenband, schwarz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E697 BNDG-F571'"/>
      <xsl:map-entry key="'Geschnitzter Holzdeckel'" select="'BNDG-A239 BNDG-G696 BNDG-G512'"/>
      <xsl:map-entry key="'Goldschmiedeeinband'" select="'BNDG-A239 BNDG-G420'"/>
      <xsl:map-entry key="'gotischer Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Gotischer Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Gotischer Holzdeckeleinband, ursprünglich mit rotem Leder bezogen'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F619'"/>
      <xsl:map-entry key="'Groliereinband'" select="'BNDG-A239 BNDG-E702 BNDG-G699 BNDG-F468'"/>
      <xsl:map-entry key="'Haifischledereinband'" select="'BNDG-A239 BNDG-E179 BNDG-F468'"/>
      <xsl:map-entry key="'Halbband'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682'"/>
      <xsl:map-entry key="'Halbfranzband'" select="'BNDG-X508 BNDG-A206 BNDG-B726 BNDG-F414 BNDG-D235 BNDG-E702'"/>
      <xsl:map-entry key="'Halbgewebeeinband'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E418'"/>
      <xsl:map-entry key="'Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, beige, auf Holzdeckeln'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband, braun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, braun, modern'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, braun, neu'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, dunkelbraun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, ehemaliger'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, frühneuzeitlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, hell'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, hellbraun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, neu'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, restauriert'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, rot, modern'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, schmucklos'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätgotisch'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätgotisch, braun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätgotisch, hell'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätgotisch, hell, auf Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband, spätgotisch, rot'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätgotisch, rot, Ziegenleder?'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätgotischer'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätmittelalterlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätmittelalterlich, auf Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband, spätmittelalterlich, rot'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätmittelalterlicher'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband, spätmittelalterllich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband auf Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband auf Holz, frühneuzeitlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband auf Holz, hell'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband auf Holz, mittelalterlich, mit Buntpapier (19. Jh.)'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband auf Holz, spätmittelalterlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband auf Holzdeckel'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halblederband mit Pappdeckel'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D235'"/>
      <xsl:map-entry key="'Halblederband über Pappe'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D235'"/>
      <xsl:map-entry key="'Halbledereinband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, auf Holzdeckeln'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband, beige'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, braun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, braun: Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband, dunkel'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, dunkelbraun: Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, hell'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, hell, neu'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, hell, neu: Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband, hell: Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband, hellbraun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, hellbraun, auf Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband, mittelalterlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, mittelbraun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, modern'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, neu'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, spätgotisch'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, spätgotisch, dunkelbraun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, spätgotisch, hell, auf Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband, spätgotischer'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, spätmittelalterlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, spätmittelalterlich, hell'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband, spätmittelalterlicher'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband auf Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband auf Holzdeckel, modern'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband auf Holzdeckeln'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband auf Holzdeckeln, spätmittelalterlich'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband auf Pappe'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D235'"/>
      <xsl:map-entry key="'Halbleder-Holzdeckelband, hellbraun'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbleinenband'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E418'"/>
      <xsl:map-entry key="'Halbleineneinband, neuzeitlich'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E418'"/>
      <xsl:map-entry key="'Halbpergamentband'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E746'"/>
      <xsl:map-entry key="'Heft'" select="'BNDG-X434 BNDG-A507 BNDG-B783'"/>
      <xsl:map-entry key="'Hellbrauner Ledereinband auf Holzdeckeln'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Hellbrauner Ledereinband auf Holzdeckeln, Byzantinische Technik'" select="'BNDG-X463 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Hellbrauner Pappdeckeleinband (ohne Bezug)'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Heller Schweinsledereinband auf Holzdeckeln'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Hirschleder-Einband?, rot'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'hochgotischer Einband ohne Stempelschmuck'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-G117'"/>
      <xsl:map-entry key="'Holzdeckel'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, brüchig'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, Buchenholz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, defekt'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, frühneuzeitlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, mit Lederbezug'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Holzdeckelband, mittelalterlicher'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, mittelalterlicher?'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, neu'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, restauriert, mit Marmorpapier überzogen'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Holzdeckelband, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, spätgotisch, erneuert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, spätgotisch, restauriert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, spätgotischer'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, spätmittelalterlicher'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, spätmittelalterlicher, defekt'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband, zeitgenössisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckelband mit Marmorpapier überzogen'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Holzdeckeleinband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, braun'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, karolingisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, neu'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, neuzeitlicher'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, Schweinslederbezug, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Holzdeckeleinband, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, spätgotischer'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, spätmittelalterlicher'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, teilweise mit braunem Wildleder bezogen'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F682 BNDG-E672'"/>
      <xsl:map-entry key="'Holzdeckeleinband, zeitgenössisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband, zeitgenössisch, grün'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeleinband mit Lederrücken'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Holzdeckeln'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckeln, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckel ohne Leder'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F549'"/>
      <xsl:map-entry key="'Holzeinband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzeinband, unfertig'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Hornband'" select="'BNDG-X876 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Hornplatteneinband, zeitgenössisch'" select="'BNDG-A532 BNDG-G153'"/>
      <xsl:map-entry key="'Hüllenband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Interimseinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Kalblederband'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbslederband'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbslederband, spätgotisch'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalikoband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E824 BNDG-F468'"/>
      <xsl:map-entry key="'Kalikoeinband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E824 BNDG-F468'"/>
      <xsl:map-entry key="'Karl-Theodor-Einband'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E702'"/>
      <xsl:map-entry key="'Kathedraleinband'" select="'BNDG-A239 BNDG-G607'"/>
      <xsl:map-entry key="'Kettenband'" select="'BNDG-X980 BNDG-A532 BNDG-B859 BNDG-D174 BNDG-N271'"/>
      <xsl:map-entry key="'Kettenband, ehemaliger'" select="'BNDG-X980 BNDG-A532 BNDG-B859 BNDG-D174 BNDG-N291'"/>
      <xsl:map-entry key="'Kettenband, ehemaliger?'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Kettenband?'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Kettenbuch?'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Kettenstichband'" select="'BNDG-A239 BNDG-B285'"/>
      <xsl:map-entry key="'Kettenstichband in Pappschuber'" select="'BNDG-A239 BNDG-B285'"/>
      <xsl:map-entry key="'Kettensticheinband'" select="'BNDG-A239 BNDG-B285'"/>
      <xsl:map-entry key="'Kettenstichheftung'" select="'BNDG-A239 BNDG-B285'"/>
      <xsl:map-entry key="'Klebepappe'" select="'BNDG-X120 BNDG-A206 BNDG-B859 BNDG-D930 BNDG-F468'"/>
      <xsl:map-entry key="'Klebepappe, alte'" select="'BNDG-X120 BNDG-A206 BNDG-B859 BNDG-D930 BNDG-F468'"/>
      <xsl:map-entry key="'Kleisterpapier-Umschlag'" select="'BNDG-A507 BNDG-D341'"/>
      <xsl:map-entry key="'Konservierungseinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Kopert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Kopertband'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Kopertband, restauriert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Kopertband, spätmittelalterlich'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Koperteinband'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Koperteinband, barock'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Koperteinband, spätmittelalterlich'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Kopert mit Stempeln und Streicheisenlinien'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'Langriemenschließe'" select="'BNDG-K763'"/>
      <xsl:map-entry key="'Leder: Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Lederband, dunkelbraun'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Lederband, spätmittelalterlich, hell'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Lederband auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holz, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holz, rot'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holz, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holz, spätmittelalterlich, dunkelbraun'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holz, spätmittelalterlich, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holz, spätmittelalterlich, rot'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Holzdeckeln'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband auf Pappe, spätmittelalterlich, hell'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband mit Blindpressung'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G747'"/>
      <xsl:map-entry key="'Lederband mit Buckeln'" select="'BNDG-A239 BNDG-A532 BNDG-B859 BNDG-E702 BNDG-M340 BNDG-F468'"/>
      <xsl:map-entry key="'Lederband mit Rollen- und Plattenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G124'"/>
      <xsl:map-entry key="'Ledereinband'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, braun'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, braun, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, gepresst'" select="'BNDG-A239 BNDG-E702 BNDG-G747 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, modern'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, neu'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, restauriert'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, schlicht, starkbeschädigt'" select="'BNDG-A239 BNDG-E702 BNDG-G720 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, braun, schmucklos'" select="'BNDG-A239 BNDG-E702 BNDG-G720 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, dunkel'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, dunkel, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, dunkelblau'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, dunkelbraun'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, dunkelbraun, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, dunkelbraun, auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, dunkelbraun, neu'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, dunkelbraun, schmucklos'" select="'BNDG-A239 BNDG-E702 BNDG-G720 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, dunkelrot'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, gotisch, braun'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, gotisch, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, grün, modern'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, mittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, modern'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, neu'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, restauriert'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, schmucklos'" select="'BNDG-A239 BNDG-E702 BNDG-G720 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, schmucklos, mittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, hell, schmucklos, mittelalterlich, restauriert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, hell, schmucklos, restauriert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, hell, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hell, spätmittelalterlich, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hellbraun'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, hellbraun, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hellbraun, modern'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hellbraun, neu'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, hellrot, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, karolingisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, karolingisch, braun, restauriert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, karolingisch, dunkel'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, karolingisch, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, karolingisch, nachgedunkelt'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, mittelbraun'" select="'BNDG-A239 BNDG-E702'"/>
      <xsl:map-entry key="'Ledereinband, mittelbraun, auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, mittelbraun, neu'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, neu'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, restauriert'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rot'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rot, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rot, auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rot, mit Goldprägung auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-G699 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rot, schmucklos, mittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-G720 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rot, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rotbraun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rötlich'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, rötlich-braun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, schwarz, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, braun'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, braun, glatt'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, braun, restauriert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, dunkelrot'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, hell, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch, rot'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotisch (süddeutsch)'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätgotischer'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlich, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlich, dunkel, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlich, glatt, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlich, rot, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlich/frühneuzeitlich, dunkel, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätmittelalterlicher'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätottonisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätottonisch, braun'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätottonisch, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätottonisch, hell, restauriert'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, spätottonisch, hell, schmucklos'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, spätromanisch, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, vorgotisch, hell, schmucklos'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, vorgotisch?, hell, schmucklos'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, vorgotisch?, schmucklos'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468 BNDG-G720'"/>
      <xsl:map-entry key="'Ledereinband, weiß'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, weiß, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, weiß, modern'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holz, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holz, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holz, spätmittelalterlich, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holz, spätmittelalterlich, hell, mit Stempeln'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckel, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, gepresst'" select="'BNDG-X717 BNDG-A532 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-D174 BNDG-G747'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, hell'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln,neuzeitlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, rot'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, spätmittelalterlich'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, spätmittelalterlich, braun'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, spätmittelalterlich, rot'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holzdeckeln, weiß'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Pappe, dunkelrot'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Pappe, hell'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Pappe, neu'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Pappe mit Goldprägung'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-G699 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband mit Goldprägung'" select="'BNDG-A239 BNDG-E702 BNDG-G699 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband über Holzdeckeln'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederhülle'" select="'BNDG-A507 BNDG-D803'"/>
      <xsl:map-entry key="'Lederschnitt-Wappeneinband'" select="'BNDG-X152 BNDG-A532 BNDG-B726 BNDG-E702 BNDG-G993 BNDG-F468'"/>
      <xsl:map-entry key="'Lederumschlag'" select="'BNDG-A507 BNDG-D803'"/>
      <xsl:map-entry key="'Leidereinband'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leinenband'" select="'BNDG-A239 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Lilienstempeleinband'" select="'BNDG-A239 BNDG-G607'"/>
      <xsl:map-entry key="'Makulatureinband'" select="'BNDG-X135 BNDG-A239'"/>
      <xsl:map-entry key="'Manuskripteinband'" select="'BNDG-X135 BNDG-A239'"/>
      <xsl:map-entry key="'Manuskriptumschlag'" select="'BNDG-X135 BNDG-A507'"/>
      <xsl:map-entry key="'Marmorpapier, mehrfarbig, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquinband, rot'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquineinband'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquin-Einband'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquineinband, rot'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquinlederband'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Medici-Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Mit braunem Leder bezogener Holzdeckeleinband, Byzantinische Technik'" select="'BNDG-X463 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Mit braunem Leder bezogener Holzdeckeleinband alla greca'" select="'BNDG-X699 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Mit dunkelbraunem Leder bezogener byzantinischer Holzdeckeleinband'" select="'BNDG-X558 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'mit hellbraunem Leder bezogener Holzdeckeleinband alla greca'" select="'BNDG-X699 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'mit rotem Leder bezogener Holzdeckeleinband alla greca'" select="'BNDG-X699 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Mit rotem Leder bezogener Holzdeckeleinband alla greca'" select="'BNDG-X699 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Mit schwarzem Leder bezogener Holzdeckeleinband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'mittelalterlicher Einband mit Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G437 BNDG-D174'"/>
      <xsl:map-entry key="'moderne Mappe'" select="'BNDG-A343'"/>
      <xsl:map-entry key="'moderner Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'moderner Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'moderner Halbpergamentband'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E746'"/>
      <xsl:map-entry key="'moderner Holzdeckel-Lederband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'moderner Lederband'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'moderner Pappband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Moiré-Einband'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Molitor-Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'neuzeitlicher Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'neuzeitlicher Einband mit Rollen- und Einzelstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'neuzeitlicher Halbfranzband'" select="'BNDG-X508 BNDG-A206 BNDG-B726 BNDG-F414 BNDG-D235 BNDG-E702'"/>
      <xsl:map-entry key="'neuzeitlicher Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'neuzeitlicher Halbpergamentband'" select="'BNDG-X642 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E746'"/>
      <xsl:map-entry key="'neuzeitlicher Lederband'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'neuzeitlicher Lederband mit Rollen- und Einzelstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'neuzeitlicher Pappband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'neuzeitlicher Pergamentband'" select="'BNDG-X876 BNDG-A239'"/>
      <xsl:map-entry key="'neuzeitlicher Samtband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Originaleinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Ottheinrich-Einband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F468 BNDG-E702 BNDG-G215'"/>
      <xsl:map-entry key="'Papier auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papierbroschur'" select="'BNDG-X434 BNDG-A507 BNDG-B783 BNDG-D941'"/>
      <xsl:map-entry key="'Papiereinband'" select="'BNDG-A239 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papiereinband, hell, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papiereinband auf Holz, neu'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papiereinband auf Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papierumschlag'" select="'BNDG-A507 BNDG-D941'"/>
      <xsl:map-entry key="'Pappband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappband, braun'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappband, grau'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappband, modern'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappband, neuzeitlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappband, neuzeitlich, grau'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappband, schmucklos'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-G117'"/>
      <xsl:map-entry key="'Pappbände'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckel'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckel, neu'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, erneuert'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, frühneuzeitlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, modern'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, neu'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, neuzeitlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, restauriert'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, spätmittelalterlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband, zeitgenössisch'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckelband mit Pergamentbezug'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckelband mit Stoffrücken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E418 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckelbd'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckeleinband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckeleinband, blau, neuzeitlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckeleinband, modern'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckeleinband, neuzeitlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappdeckeleinband mit Bezug aus braunem Muschelmarmorpapier. Lederrücken und ecken.'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E340 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckeleinband mit Papier bezogen'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckeleinband mit Papier bezogen, neuzeitlich'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckeleinband mit Pergament bezogen'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckeleinband mit Pergamentüberzug'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pappdeckeln in Schuber'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, braun'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, erneuert, mit Marmorpapier'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband, grau'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, hell'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, hellbraun'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, mit Maroquin überzogen, rotbraun'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband, mittelbraun'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, modern'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, schwarz'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband, zeitgenössisch'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappeinband mit Buntpapier'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband mit Lederrücken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband mit Lederrücken und -ecken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband mit Pergamentdecke'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband mit Pergamentüberzug'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pappumschlag'" select="'BNDG-A507 BNDG-D235'"/>
      <xsl:map-entry key="'Pappumschlag, gelb'" select="'BNDG-A507 BNDG-D235'"/>
      <xsl:map-entry key="'Pappumschlag, grau'" select="'BNDG-A507 BNDG-D235'"/>
      <xsl:map-entry key="'Paramenteinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Pergamentband'" select="'BNDG-X876 BNDG-A239'"/>
      <xsl:map-entry key="'Pergamenteinband'" select="'BNDG-X876 BNDG-A239'"/>
      <xsl:map-entry key="'Pergamenteinband, flexibel'" select="'BNDG-X876 BNDG-A507 BNDG-D864'"/>
      <xsl:map-entry key="'Pergamenteinband auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergamenteinband auf Pappdeckeln'" select="'BNDG-X876 BNDG-A532 BNDG-E746 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Pergamenteinband auf Pappe'" select="'BNDG-X876 BNDG-A532 BNDG-E746 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Pergamentimitatband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Pergamentkopert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Pergamentkoperteinband'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Pergamentumschlag'" select="'BNDG-X876 BNDG-A507 BNDG-D864'"/>
      <xsl:map-entry key="'Plattenstempel'" select="'BNDG-G124'"/>
      <xsl:map-entry key="'Prachteinband'" select="'BNDG-X886 BNDG-A532 BNDG-G607'"/>
      <xsl:map-entry key="'Rauledereinband'" select="'BNDG-A239 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Remboitage'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Renaissance-Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Renaissance-Einband / Barockeinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Renaissance-Einband mit Einzel-, Rollen- und Plattenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525'"/>
      <xsl:map-entry key="'Renaissance-Einband mit Einzelstempeln'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882'"/>
      <xsl:map-entry key="'Renaissance-Einband mit Einzel- und Rollenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'Renaissance-Einband mit Plattenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G124'"/>
      <xsl:map-entry key="'Renaissance-Einband mit Rollenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525'"/>
      <xsl:map-entry key="'Renaissance-Einband mit Rollen- und Plattenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-G124'"/>
      <xsl:map-entry key="'Renaissanceeinband ohne Stempelschmuck'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Renaissance-Einband ohne Stempelschmuck'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Renaissance-Ledereinband'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Rindsledereinband, spätgotisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E913 BNDG-F468'"/>
      <xsl:map-entry key="'Rokokoeinband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Rollenstempelband'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525'"/>
      <xsl:map-entry key="'Romanischer Einband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F468 BNDG-E702 BNDG-G747'"/>
      <xsl:map-entry key="'Roter Ledereinband auf Holzdeckeln, Byzantinische Technik'" select="'BNDG-X463 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Sämischleder, mittelbraun, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Sämischledereinband'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Sämischledereinband, mittelblau'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Sämischledereinband, spätottonisch'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Samtband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Samteinband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Samteinband, rot'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Samteinband, rot (ehemals)'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Samteinband, violett'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E491 BNDG-F468'"/>
      <xsl:map-entry key="'Schaflederband, spätmittelalterlich, rot'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-E698 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schaflederband, spätmittelalterlich, rot, auf Holz'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-E698 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schafledereinband'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-E698 BNDG-F468'"/>
      <xsl:map-entry key="'Schedel-Einband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F468 BNDG-E702 BNDG-G607'"/>
      <xsl:map-entry key="'Schmuckband'" select="'BNDG-X886 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-G607'"/>
      <xsl:map-entry key="'Schwarzer Ledereinband auf Holzdeckeln, Byzantinische Technik'" select="'BNDG-X463 BNDG-A532 BNDG-B118 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, dunkel, spätmittelalterlich, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, hell, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, hell, spätmittelalterlich, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, spätmittelalterlich'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, spätmittelalterlich, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, spätmittelalterlich, hell'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband, weiß'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband auf Holz, spätmittelalterlich'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederband auf Holz, spätmittelalterlich, hell'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, braun'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, gepresst'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-G747 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, glatt'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, hell, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, hell, gepresst'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-G747 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, spätgotisch'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, spätmittelalterlicher'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, weiß'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, weiß, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, weiß, auf mittelalterlichem Holzdeckel'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband, weiß, gepresst, auf Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband auf Holzdeckeln'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband auf Holzdeckeln, weiß'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsledereinband auf Pappe'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Seidenband'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Seidenbrokateinband, auf Holz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E757 BNDG-F468'"/>
      <xsl:map-entry key="'Seideneinband'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Seideneinband, auf Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seideneinband, blau, auf Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seideneinband, dunkelrot, auf Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seideneinband, rot, auf Pappe'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D235'"/>
      <xsl:map-entry key="'Seidensamt'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Seidensamtbindung, grün, ehem., auf Holzdeckeln'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seidensamteinband'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Silbereinband'" select="'BNDG-X886 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-G617'"/>
      <xsl:map-entry key="'Silbereinband, vergoldet'" select="'BNDG-X886 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-G617 BNDG-G420'"/>
      <xsl:map-entry key="'Silbereinband mit vergoldeter Decke'" select="'BNDG-X886 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-G617 BNDG-G420'"/>
      <xsl:map-entry key="'Silberemaileinband'" select="'BNDG-X886 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-G617 BNDG-G430'"/>
      <xsl:map-entry key="'spätgotischer Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'spätgotischer Einband, unverziert'" select="'BNDG-A239 BNDG-G720'"/>
      <xsl:map-entry key="'spätgotischer Einband mit Einzelstempeln'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'spätgotischer Einband mit Einzel- und Rollenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-G525 BNDG-D174'"/>
      <xsl:map-entry key="'spätgotischer Einband mit Plattenstempeln'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G124 BNDG-D174'"/>
      <xsl:map-entry key="'spätgotischer Einband mit Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G437 BNDG-D174'"/>
      <xsl:map-entry key="'spätgotischer Einband mit Streicheisenlinien?'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G437 BNDG-D174'"/>
      <xsl:map-entry key="'spätgotischer Einband ohne Stempelschmuck'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-G720'"/>
      <xsl:map-entry key="'spätgotischer Eonband mit Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Spätgotischer Holzdeckeleinband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'spätgotischer Koperteinband'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'spätgotischer Koperteinband mit Einzelstempeln'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859 BNDG-G882'"/>
      <xsl:map-entry key="'spätgotischer Koperteinband mit Kettenstichheftung'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B285'"/>
      <xsl:map-entry key="'spätgotischer Koperteinband mit Langstichheftung'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B993'"/>
      <xsl:map-entry key="'spätgotischer Ledereinband mit Rollenstempel'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G525 BNDG-D174'"/>
      <xsl:map-entry key="'spätmittelalterlicher Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'spätmittelalterlicher Einband mit Blindstempeln'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'spätmittelalterlicher Einband mit Blindstempeln und Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-D174 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Einband mit Blindstempeln und Streicheisenlinien spätmittelalterlicher Einband mit Blindstempeln und Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-D174 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Einband mit Einzelstempeln und Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-D174 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Einband mit Streicheisenlinien'" select="'BNDG-X717 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-D174 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Spätmittelalterlicher Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'spätmittelalterlicher Halblederband mit Blindstempeln und Streicheisenlinien'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174 BNDG-G882 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Halblederband mit Streicheisenlinien'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Kopertband'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'spätmittelalterlicher Kopertband mit Streicheisenlinien'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859 BNDG-G437'"/>
      <xsl:map-entry key="'spätmittelalterlicher Lederband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Spätmittelalterlicher Lederband, rot, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Spätmittelalterlicher Lederband auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Spätmittelalterlicher Schaflederband, blau, auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E698 BNDG-F468'"/>
      <xsl:map-entry key="'Spätmittelalterlicher Schweinslederband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'spätmittelalterlicher St. Emmeramer Stempelband auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'spätmittelalterlicher Stempelband auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'spätromanischer Lederhalbband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, braun, spätmittelalterlich, auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, hell, auf Holz (St. Emmeram)'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, hell, spätmittelalterlich, auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, hell, spätmittelalterlich, auf Holz (St. Emmeram)'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, spätmittelalterlich, hell'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, spätmittelalterlich, hell, auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, spätmittelalterlich, hell (St. Emmeram)'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband, spätmittelalterlich, rot, auf Holz'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Stempelband auf Holz, spätmittelalterlich, dunkelbraun'" select="'BNDG-X986 BNDG-A206 BNDG-B859 BNDG-E702 BNDG-F468 BNDG-G882 BNDG-D174'"/>
      <xsl:map-entry key="'Umschlag'" select="'BNDG-A507'"/>
      <xsl:map-entry key="'Ungebunden in Pappschuber'" select="'BNDG-A460'"/>
      <xsl:map-entry key="'Velourslederband, spätmittelalterlich, auf Holz, blau'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Velourslederband auf Holz, restauriert'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Veloursledereinband auf Holz'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'vorgotischer Einband'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'vorgotischer Einband?'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Widmanstetter-Einband'" select="'BNDG-A532 BNDG-B726 BNDG-F468 BNDG-E702 BNDG-G607'"/>
      <xsl:map-entry key="'Widmanstetter-Einband: heller Schweinsledereinband auf Holzdeckeln'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Wildlederband auf Holz'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Wildledereinband'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Wildledereinband, blaugrün, auf Holz'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Wildledereinband, hellbraun'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Wildledereinband, neu, weiß'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Wildleder über Holzdeckeln'" select="'BNDG-X462 BNDG-A532 BNDG-B859 BNDG-E672 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Ziegenlederband'" select="'BNDG-A239 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Zierband'" select="'BNDG-X886 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-G607'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="BNDG-5260-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Brokatpapier (Hefte 18a, 18b)'" select="'BNDG-A507 BNDG-D401'"/>
      <xsl:map-entry key="'Buntpapier : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Buntpapier (Heft 15)'" select="'BNDG-A507 BNDG-D431'"/>
      <xsl:map-entry key="'Edelstein'" select="'BNDG-G863'"/>
      <xsl:map-entry key="'Edelsteine'" select="'BNDG-G863'"/>
      <xsl:map-entry key="'Elfenbein'" select="'BNDG-G924'"/>
      <xsl:map-entry key="'Elfenbeinfeld'" select="'BNDG-G924'"/>
      <xsl:map-entry key="'Elfenbeinrelief'" select="'BNDG-G924'"/>
      <xsl:map-entry key="'Email'" select="'BNDG-G430'"/>
      <xsl:map-entry key="'Glanzlederüberzug, dunkelbraun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Glanzpapier (grün) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Haifischleder (schwarz): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E179 BNDG-F468'"/>
      <xsl:map-entry key="'Halbedelstein'" select="'BNDG-G863'"/>
      <xsl:map-entry key="'Halbleder: Pappe'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D235'"/>
      <xsl:map-entry key="'Halbleder (braun)'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbleder (hell)'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbleder (hellbraun)'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbleder (rot)'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Halbledereinband: Holz'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702 BNDG-D174'"/>
      <xsl:map-entry key="'Halbledereinband (hell)'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Holz : Leder (braun)'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Holz (Rücken Leder)'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Holzdeckelband mit 1/1 Schafslederüberzug'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E698 BNDG-F468'"/>
      <xsl:map-entry key="'Holzdeckeleinband'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174'"/>
      <xsl:map-entry key="'Holzdeckel mit Lederrändern'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Horn'" select="'BNDG-G153'"/>
      <xsl:map-entry key="'Hornplatte'" select="'BNDG-G153'"/>
      <xsl:map-entry key="'Kalbleder: Holz'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbleder : Holz'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbleder: Pappe'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbleder : Pappe'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbleder (hell): Holz'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbleder (rotbraun)'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder, braun'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder, hellbraun'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder : Holz'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder : Pappe'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (braun)'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (braun): Holz'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (braun) : Pappe'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (dunkelbraun)'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (hellbraun)'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (rot)'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbsleder (schwarzbraun)'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbslederband'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kalbslederbezug'" select="'BNDG-X990 BNDG-A532 BNDG-B859 BNDG-E456 BNDG-F468'"/>
      <xsl:map-entry key="'Kaliko (grün) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E824 BNDG-D235 BNDG-F468'"/>
      <xsl:map-entry key="'Kalikoband'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-E824 BNDG-F468'"/>
      <xsl:map-entry key="'Kiebitzpapierüberzug'" select="'BNDG-A239 BNDG-E317 BNDG-F468'"/>
      <xsl:map-entry key="'Klebepappe'" select="'BNDG-X120 BNDG-A206 BNDG-B859 BNDG-D930'"/>
      <xsl:map-entry key="'Kleisterpapier : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E359 BNDG-F468'"/>
      <xsl:map-entry key="'Kunstleder : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E798 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, braun : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, dunkelbraun : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, hellbraun : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, mittelbraun : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, rotgefärbt : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, rot gefärbt : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder, weiß : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder: Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder : Holz?'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder : Leder'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Leder: Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder : Pergament'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Leder (beige) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (blau): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (blau) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder(braun): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (braun): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (braun) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (braun): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (braun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (braun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkel) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkel) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelblau) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelbraun): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelbraun) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelbraun) : Holz bzw. Pappe'" select="'BNDG-A532 BNDG-B726 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelbraun): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelbraun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelgrün) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelgrün) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkell): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelrot) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (dunkelrot) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (gelb): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (gelbbraun) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (gelbbraun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (gelblich) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (grau) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (grün) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (grünblau): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hell, gelblich) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder(hell): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hell): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hell) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hell): Leder'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Leder (hell): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hell) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hellbeige): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hellbeige) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hellbraun, grau marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hellbraun) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hellbraun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (hellrot) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (mittelbraun): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (mittelbraun): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (rot): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (rot) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (rot): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (rot) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (rotbraun) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (rotbraun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (schwarz) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (schwarz): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (schwarz) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (weiß) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leder (weiß) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederbd'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederbezug'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband, beige'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband (hellbeige)'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Ledereinband auf Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederrücken'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, blau'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, braun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, braun, beschädigt'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, dunkelbraun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, grau'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, grünlich-blau'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, grünlich-braun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, hell'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, hellbraun'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, hellbraun, schadhaft'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, restauriert'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, rot'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, rot, beschädigt'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, rotgefärbt'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, schwarzgefärbt'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Lederüberzug, weiß'" select="'BNDG-A239 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Leinen, gestickt'" select="'BNDG-A239 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Leinen : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-D235 BNDG-E418 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Leinen (braun): Holz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-D174 BNDG-E418 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Leinen (braunrot) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-D235 BNDG-E418 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Leinen (grün) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-D235 BNDG-E418 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Leinenrücken'" select="'BNDG-A239 BNDG-E697 BNDG-F468'"/>
      <xsl:map-entry key="'Marmorpapier : Pappe'" select="'BNDG-A532 BNDG-D235 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Marmorpapier (Hefte 1-3, 19, 20)'" select="'BNDG-A507 BNDG-D624'"/>
      <xsl:map-entry key="'Marmorpapierüberzug'" select="'BNDG-A239 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquin'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquin (braun)'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Maroquin (rot)'" select="'BNDG-X411 BNDG-A532 BNDG-B859 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Metallbeschlag, verziert'" select="'BNDG-A239 BNDG-M340'"/>
      <xsl:map-entry key="'Moderner Pappeinband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Nigerziegenleder'" select="'BNDG-A239 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Papier: Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-F468 BNDG-D174 BNDG-E978'"/>
      <xsl:map-entry key="'Papier : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-F468 BNDG-D174 BNDG-E978'"/>
      <xsl:map-entry key="'Papier: Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E978'"/>
      <xsl:map-entry key="'Papier : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E978'"/>
      <xsl:map-entry key="'Papier : Pappe (Lederbuchrücken und -ecken)'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E978 BNDG-E702'"/>
      <xsl:map-entry key="'Papier : Pappe (Pergamentrücken und -ecken)'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E978 BNDG-E746'"/>
      <xsl:map-entry key="'Papier (beige) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E978'"/>
      <xsl:map-entry key="'Papier (blau-braun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (blau marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (braun, marmoriert)'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (braun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E978'"/>
      <xsl:map-entry key="'Papier (braun-gelb marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (bräunlich marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (braun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (braun marmoriert) : Pappe mit Lederbuchrücken und -ecken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340 BNDG-E702'"/>
      <xsl:map-entry key="'Papier (braun marmoriert) : Pappe mit Lederecken und -rücken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340 BNDG-E702'"/>
      <xsl:map-entry key="'Papier (braun marmoriert) : Pappe mit Lederrücken und -ecken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340 BNDG-E702'"/>
      <xsl:map-entry key="'Papier (braun marmoriert) : Pappe mit Pergamentrücken und -ecken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340 BNDG-E746'"/>
      <xsl:map-entry key="'Papier (dunkelbraun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E851'"/>
      <xsl:map-entry key="'Papier (dunkelgraubraun) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E851'"/>
      <xsl:map-entry key="'Papier (geblümt) : Pappe (Lederrücken und -ecken)'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E851 BNDG-E702'"/>
      <xsl:map-entry key="'Papier (gelb) : Pappe mit Lederrücken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E851 BNDG-E702'"/>
      <xsl:map-entry key="'Papier (gelb-braun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Papier (grau) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papier (grau-braun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (grau marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (grün-braun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (hellbraun): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-F468 BNDG-D174 BNDG-E978'"/>
      <xsl:map-entry key="'Papier (hellbraun marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-F468 BNDG-E340'"/>
      <xsl:map-entry key="'Papier (Lose Lagen in Papierumschlag)'" select="'BNDG-A343 BNDG-D941'"/>
      <xsl:map-entry key="'Papier (marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Papier (rosa marmoriert) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Papier (schwarz-braun geprenkelt): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E317 BNDG-F468'"/>
      <xsl:map-entry key="'Papier (schwarz-braun marmoriert): Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E340 BNDG-F468'"/>
      <xsl:map-entry key="'Papierband mit gebrochenem Rücken'" select="'BNDG-A239 BNDG-D941'"/>
      <xsl:map-entry key="'Papierbezug'" select="'BNDG-A239 BNDG-E978 BNDG-F468'"/>
      <xsl:map-entry key="'Papierbezug, blau'" select="'BNDG-A239 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Papierbezug, braun'" select="'BNDG-A239 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Papierbezug, grün'" select="'BNDG-A239 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Papierbezug, türkis'" select="'BNDG-A239 BNDG-E851 BNDG-F468'"/>
      <xsl:map-entry key="'Papierüberzug (braun-schwarz gesprenkelt)'" select="'BNDG-A239 BNDG-E317 BNDG-F468'"/>
      <xsl:map-entry key="'Papierumschlag'" select="'BNDG-A507 BNDG-D941'"/>
      <xsl:map-entry key="'Pappdeckeleinband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappe : Leder (braun)'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E702 BNDG-F468'"/>
      <xsl:map-entry key="'Pappeinband'" select="'BNDG-X514 BNDG-A532 BNDG-D235'"/>
      <xsl:map-entry key="'Pappe mit Pergamentrücken'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F682'"/>
      <xsl:map-entry key="'Pergament:Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergament : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergament : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergament (grün) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergament (grün) : Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergament (hell): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergamenteinband'" select="'BNDG-X876 BNDG-A239'"/>
      <xsl:map-entry key="'Pergamenths. : Pappe'" select="'BNDG-X135 BNDG-A532 BNDG-D235 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergament-Klebeband'" select="'BNDG-X120 BNDG-A206 BNDG-B859 BNDG-D930 BNDG-F468'"/>
      <xsl:map-entry key="'Pergamentkopert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Pergamentüberzug'" select="'BNDG-A239 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Pergamentumschlag'" select="'BNDG-A507 BNDG-D864'"/>
      <xsl:map-entry key="'Rauleder (braun): Pappe'" select="'BNDG-X514 BNDG-A532 BNDG-D235 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Rindleder: Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E913 BNDG-F468'"/>
      <xsl:map-entry key="'Rücken mit Pergamentüberzug'" select="'BNDG-A239 BNDG-E746 BNDG-F468'"/>
      <xsl:map-entry key="'Samt : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D235'"/>
      <xsl:map-entry key="'Samt (blau) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D235'"/>
      <xsl:map-entry key="'Samt (braun) : Holz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D174'"/>
      <xsl:map-entry key="'Samt (dunkelrot) : Holz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D174'"/>
      <xsl:map-entry key="'Samt (grün)'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491'"/>
      <xsl:map-entry key="'Samt (grün) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D235'"/>
      <xsl:map-entry key="'Samt (rot)'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491'"/>
      <xsl:map-entry key="'Samt (rot) :Holz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D174'"/>
      <xsl:map-entry key="'Samt (rot) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D235'"/>
      <xsl:map-entry key="'Samt (schwarz)'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491'"/>
      <xsl:map-entry key="'Samt (schwarz) : Pappe'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D235'"/>
      <xsl:map-entry key="'Samt (violett)'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491'"/>
      <xsl:map-entry key="'Samt (violett): Holz'" select="'BNDG-X605 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E491 BNDG-D174'"/>
      <xsl:map-entry key="'Schafleder: Holz'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698 BNDG-D174'"/>
      <xsl:map-entry key="'Schafleder : Holz'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698 BNDG-D174'"/>
      <xsl:map-entry key="'Schafleder: Pappe'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698 BNDG-D235'"/>
      <xsl:map-entry key="'Schafleder (hell) : Holz'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698 BNDG-D174'"/>
      <xsl:map-entry key="'Schaflederüberzug'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698'"/>
      <xsl:map-entry key="'Schafslederband'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698'"/>
      <xsl:map-entry key="'Schafslederbezug'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698'"/>
      <xsl:map-entry key="'Schafslederbezug : Holz'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698 BNDG-D174'"/>
      <xsl:map-entry key="'Schafslederüberzug'" select="'BNDG-X972 BNDG-A532 BNDG-B859 BNDG-F468 BNDG-E698'"/>
      <xsl:map-entry key="'Schweinleder : Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsleder, hell'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsleder: Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsleder : Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsleder (beige) : Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsleder (hell) : Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinsleder (rot): Holz'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'Schweinslederbezug'" select="'BNDG-X974 BNDG-A532 BNDG-B859 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Seide : Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seide (rosa)'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Seide (rosa): Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seide (rot) : Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Seide (schwarz)'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501'"/>
      <xsl:map-entry key="'Seide (schwarz): Pappe'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D235'"/>
      <xsl:map-entry key="'Seidensamt (rot): Holz'" select="'BNDG-X160 BNDG-A532 BNDG-B859 BNDG-E613 BNDG-F501 BNDG-D174'"/>
      <xsl:map-entry key="'Stoff (?) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-F468'"/>
      <xsl:map-entry key="'unverziertem Schweinslederüberzug'" select="'BNDG-A239 BNDG-E244 BNDG-F468'"/>
      <xsl:map-entry key="'Wildleder: Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Wildleder (braun) : Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E672 BNDG-F468'"/>
      <xsl:map-entry key="'Ziegenleder: Holz'" select="'BNDG-X831 BNDG-A532 BNDG-B726 BNDG-D174 BNDG-E150 BNDG-F468'"/>
      <xsl:map-entry key="'Ziegenlederbezug'" select="'BNDG-A239 BNDG-E150 BNDG-F468'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="BNDG-5320-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'altes Kopert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Buchkapsel'" select="'BNDG-X370 BNDG-A239'"/>
      <xsl:map-entry key="'Buchkasten'" select="'BNDG-X370 BNDG-A239'"/>
      <xsl:map-entry key="'Einband (alter)'" select="'BNDG-A239'"/>
      <xsl:map-entry key="'Pergamentkopert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Schließbeschlag'" select="'BNDG-M340'"/>
      <xsl:map-entry key="'Schließe'" select="'BNDG-K706'"/>
      <xsl:map-entry key="'Umschlag'" select="'BNDG-A507'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="CODC-5260-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Birkenrinde'" select="'CODC-A601'"/>
      <xsl:map-entry key="'Bombyzinpapier'" select="'CODC-A725'"/>
      <xsl:map-entry key="'Kalbpergament'" select="'CODC-A915'"/>
      <xsl:map-entry key="'Kopierpapier'" select="'CODC-A783'"/>
      <xsl:map-entry key="'Palmblatt'" select="'CODC-A480'"/>
      <xsl:map-entry key="'paper'" select="'CODC-A366'"/>
      <xsl:map-entry key="'Papier'" select="'CODC-A366'"/>
      <xsl:map-entry key="'Papier, die zwei ersten und letzten Blätter (Schutzblätter) Pergament und unbeschrieben'" select="'CODC-A366'"/>
      <xsl:map-entry key="'Papier (or.)'" select="'CODC-A725'"/>
      <xsl:map-entry key="'Papier (or.-arab.)'" select="'CODC-A725'"/>
      <xsl:map-entry key="'Papier + Pergamentfragment auf dem Einband'" select="'CODC-A366'"/>
      <xsl:map-entry key="'Papier und Pergament (Vorsatz)'" select="'CODC-A366'"/>
      <xsl:map-entry key="'Papyrus'" select="'CODC-A194'"/>
      <xsl:map-entry key="'Parchemin'" select="'CODC-A800'"/>
      <xsl:map-entry key="'parchment'" select="'CODC-A800'"/>
      <xsl:map-entry key="'Perg'" select="'CODC-A800'"/>
      <xsl:map-entry key="'Perg.'" select="'CODC-A800'"/>
      <xsl:map-entry key="'Pergament; davor und dahinter unbeschriebene Bl. - Papier'" select="'CODC-A800'"/>
      <xsl:map-entry key="'Pergament und Leimabdruck auf Papier'" select="'CODC-A800'"/>
      <xsl:map-entry key="'Schreibmaschinenpapier'" select="'CODC-A783'"/>
      <xsl:map-entry key="'Vellum'" select="'CODC-A800'"/>
      <xsl:map-entry key="'Wachs'" select="'CODC-A635'"/>
      <xsl:map-entry key="'Ziegenpergament'" select="'CODC-A794'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="BNDG-5300-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Blindpressung'" select="'BNDG-G747'"/>
      <xsl:map-entry key="'Blindstempel'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einbandstempel'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel, (teilweise Gold)'" select="'BNDG-G292 BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel, frühbarocke'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel, gold geprägt'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Einzelstempel, gotische'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel, gotischer'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel, vergoldet'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Einzelstempel (blind)'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzelstempel (Gold)'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Einzelstempel (Rauschel)'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Einzelstempeln'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Einzel- und Rollenstempel'" select="'BNDG-G882 BNDG-G525'"/>
      <xsl:map-entry key="'Einzel- und Rollenstempeln in Blindpressung'" select="'BNDG-G882 BNDG-G525'"/>
      <xsl:map-entry key="'Farbschnitt'" select="'BNDG-H788'"/>
      <xsl:map-entry key="'Farbschnitt, blau (punziert)'" select="'BNDG-H139 BNDG-H505'"/>
      <xsl:map-entry key="'Farbschnitt (gelb)'" select="'BNDG-H819'"/>
      <xsl:map-entry key="'Farbschnitt (grün)'" select="'BNDG-H682'"/>
      <xsl:map-entry key="'Farbschnitt (Punktmuster)'" select="'BNDG-H783'"/>
      <xsl:map-entry key="'Farbschnitt (Rankwerk)'" select="'BNDG-H788'"/>
      <xsl:map-entry key="'Farbschnitt (rot)'" select="'BNDG-H873'"/>
      <xsl:map-entry key="'Farbschnitt (violett)'" select="'BNDG-H918'"/>
      <xsl:map-entry key="'Goldbeschlag'" select="'BNDG-M340'"/>
      <xsl:map-entry key="'Golddruck'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Goldfilet'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Goldfilete'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Goldlinien'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Goldprägung'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Goldpressung'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Goldschnitt'" select="'BNDG-H589'"/>
      <xsl:map-entry key="'Goldschnitt (alt)'" select="'BNDG-H589'"/>
      <xsl:map-entry key="'Goldschnitt (punziert)'" select="'BNDG-H589 BNDG-H505'"/>
      <xsl:map-entry key="'Goldschnitt mit Punzierung'" select="'BNDG-H589 BNDG-H505'"/>
      <xsl:map-entry key="'Goldstempel'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Halblederband'" select="'BNDG-X497 BNDG-A206 BNDG-B859 BNDG-F682 BNDG-E702'"/>
      <xsl:map-entry key="'Hülleneinband'" select="'BNDG-B285'"/>
      <xsl:map-entry key="'Kopert'" select="'BNDG-X839 BNDG-A960 BNDG-D864 BNDG-B859'"/>
      <xsl:map-entry key="'Langstichheftung'" select="'BNDG-B993'"/>
      <xsl:map-entry key="'Lederschnitt'" select="'BNDG-G993'"/>
      <xsl:map-entry key="'Lederzeichnung'" select="'BNDG-E702 BNDG-G550 BNDG-F468'"/>
      <xsl:map-entry key="'Metallbeschläge'" select="'BNDG-M340'"/>
      <xsl:map-entry key="'Plattenstempel'" select="'BNDG-G124'"/>
      <xsl:map-entry key="'Plattenstempel (blind)'" select="'BNDG-G124'"/>
      <xsl:map-entry key="'Plattenstempel (Gold)'" select="'BNDG-G248'"/>
      <xsl:map-entry key="'Plattenstempel (Rauschel)'" select="'BNDG-G248'"/>
      <xsl:map-entry key="'Prägedruck'" select="'BNDG-G747'"/>
      <xsl:map-entry key="'Prägestempel'" select="'BNDG-G882'"/>
      <xsl:map-entry key="'Prägestempel, gold'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Prägung (Gold)'" select="'BNDG-G699'"/>
      <xsl:map-entry key="'Rollenstempel'" select="'BNDG-G525'"/>
      <xsl:map-entry key="'Rollenstempel, floral'" select="'BNDG-G525'"/>
      <xsl:map-entry key="'Rollenstempel (blind)'" select="'BNDG-G525'"/>
      <xsl:map-entry key="'Rollenstempel (Gold)'" select="'BNDG-G246'"/>
      <xsl:map-entry key="'Rollenstempel (Rauschel)'" select="'BNDG-G246'"/>
      <xsl:map-entry key="'Rollenstempel und Blindstempel'" select="'BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'Rollenstempel und Einzelstempel'" select="'BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'Rollenstempel und Platten mit Schriftbändern'" select="'BNDG-G525 BNDG-G124'"/>
      <xsl:map-entry key="'Rollen- und Einzelstempel'" select="'BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'Rollen- und Plattenstempel'" select="'BNDG-G525 BNDG-G124'"/>
      <xsl:map-entry key="'Roll- und Plattenpressung, vergoldet'" select="'BNDG-G246 BNDG-G248'"/>
      <xsl:map-entry key="'Rundpunzen, vergoldet'" select="'BNDG-G270'"/>
      <xsl:map-entry key="'Steicheisenlinien'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Stempel (Gold)'" select="'BNDG-G292'"/>
      <xsl:map-entry key="'Streicheisenlinien'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Streicheisenlinien, Einzel- und Plattenstempel'" select="'BNDG-G437 BNDG-G882 BNDG-G124'"/>
      <xsl:map-entry key="'Streicheisenlinien, Einzel- und Rollenstempel'" select="'BNDG-G437 BNDG-G882 BNDG-G525'"/>
      <xsl:map-entry key="'Streicheisenlinien, Rollen- und Einzelstempel'" select="'BNDG-G437 BNDG-G882 BNDG-G525'"/>
      <xsl:map-entry key="'Streicheisenlinien, Rollen- und Plattenstempel'" select="'BNDG-G437 BNDG-G525 BNDG-G124'"/>
      <xsl:map-entry key="'Streicheisenlinien (blind)'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Streicheisenlinien (Gold)'" select="'BNDG-G446'"/>
      <xsl:map-entry key="'Streicheisenlinien (Rauschel)'" select="'BNDG-G446'"/>
      <xsl:map-entry key="'Streicheisenlinien mit Rollen- und Einzelstempeln'" select="'BNDG-G437 BNDG-G525 BNDG-G882'"/>
      <xsl:map-entry key="'Streicheisenlinien und Einzelstempel'" select="'BNDG-G437 BNDG-G882'"/>
      <xsl:map-entry key="'Streicheisenlinien und Einzelstempel?'" select="'BNDG-G437 BNDG-G882'"/>
      <xsl:map-entry key="'Streicheisenlinien und Einzelstempeln'" select="'BNDG-G437 BNDG-G882'"/>
      <xsl:map-entry key="'Streicheisenlinien und mehreren Einzelstempel'" select="'BNDG-G437 BNDG-G882'"/>
      <xsl:map-entry key="'Streicheisenlinien und Rollenstempel'" select="'BNDG-G437 BNDG-G525'"/>
      <xsl:map-entry key="'Streicheisenlinien und Stempel'" select="'BNDG-G437 BNDG-G882'"/>
      <xsl:map-entry key="'Streicheisenliniern'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Streicheisenlinierung'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Streicheisenmuster'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Streicheisenverzierung'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Streicheisenverzierung (Rauschel)'" select="'BNDG-G446'"/>
      <xsl:map-entry key="'Streustempel (Gold)'" select="'BNDG-G248'"/>
      <xsl:map-entry key="'Stricheisenlinien'" select="'BNDG-G437'"/>
      <xsl:map-entry key="'Wappensupralibros (Gold)'" select="'BNDG-G215'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="CODC-5382-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'(Groß)-Folio'" select="'CODC-B460'"/>
      <xsl:map-entry key="'12°'" select="'CODC-B200'"/>
      <xsl:map-entry key="'12° format'" select="'CODC-B200'"/>
      <xsl:map-entry key="'16°'" select="'CODC-B200'"/>
      <xsl:map-entry key="'19 x 29 cm'" select="'CODC-B727'"/>
      <xsl:map-entry key="'2°'" select="'CODC-B727'"/>
      <xsl:map-entry key="'2° (fast 4°)'" select="'CODC-B727'"/>
      <xsl:map-entry key="'2° 8°'" select="'CODC-B727'"/>
      <xsl:map-entry key="'4°'" select="'CODC-B199'"/>
      <xsl:map-entry key="'4° (fast 2°)'" select="'CODC-B199'"/>
      <xsl:map-entry key="'4° format'" select="'CODC-B199'"/>
      <xsl:map-entry key="'4 quart'" select="'CODC-B199'"/>
      <xsl:map-entry key="'8°'" select="'CODC-B653'"/>
      <xsl:map-entry key="'8° (fast 4°)'" select="'CODC-B653'"/>
      <xsl:map-entry key="'big 4° format („in forma 4° majori“)'" select="'CODC-B199'"/>
      <xsl:map-entry key="'duodez'" select="'CODC-B200'"/>
      <xsl:map-entry key="'Duodezformat'" select="'CODC-B200'"/>
      <xsl:map-entry key="'Duodez?'" select="'CODC-B200'"/>
      <xsl:map-entry key="'Folio, auf Quart zusammengefaltet'" select="'CODC-B727 CODC-B199'"/>
      <xsl:map-entry key="'Folio?'" select="'CODC-B727'"/>
      <xsl:map-entry key="'Folio / Quart'" select="'CODC-B727 CODC-B199'"/>
      <xsl:map-entry key="'Folioformat'" select="'CODC-B727'"/>
      <xsl:map-entry key="'Folio quer'" select="'CODC-B727 CODC-B978'"/>
      <xsl:map-entry key="'giant size, i. e. large-sized'" select="'CODC-B460'"/>
      <xsl:map-entry key="'gr. 2°'" select="'CODC-B460'"/>
      <xsl:map-entry key="'gr.-2°'" select="'CODC-B460'"/>
      <xsl:map-entry key="'gr.-4°'" select="'CODC-B199'"/>
      <xsl:map-entry key="'gr.-8°'" select="'CODC-B653'"/>
      <xsl:map-entry key="'gr.-8° (fast 4°)'" select="'CODC-B653'"/>
      <xsl:map-entry key="'gr-2°'" select="'CODC-B460'"/>
      <xsl:map-entry key="'gr-8°'" select="'CODC-B653'"/>
      <xsl:map-entry key="'groß-2°'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Großfolio'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Groß-Folio'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Großfolio?'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Groß-Folio?'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Großfolio (?)'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Groß-Folio (?)'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Groß-Folio (aber nicht Sonderstandort)'" select="'CODC-B460'"/>
      <xsl:map-entry key="'Groß-Oktav'" select="'CODC-B653'"/>
      <xsl:map-entry key="'Groß-Quart'" select="'CODC-B199'"/>
      <xsl:map-entry key="'hoch-4°'" select="'CODC-B199'"/>
      <xsl:map-entry key="'hoch u. schmal 4°'" select="'CODC-B199 CODC-B865'"/>
      <xsl:map-entry key="'hoch- u. schmal-4°'" select="'CODC-B199 CODC-B865'"/>
      <xsl:map-entry key="'kl.-2°'" select="'CODC-B727'"/>
      <xsl:map-entry key="'kl.-4°'" select="'CODC-B199'"/>
      <xsl:map-entry key="'kl.-8°'" select="'CODC-B653'"/>
      <xsl:map-entry key="'kl. fol.'" select="'CODC-B727'"/>
      <xsl:map-entry key="'klein 2°'" select="'CODC-B727'"/>
      <xsl:map-entry key="'klein-2°'" select="'CODC-B727'"/>
      <xsl:map-entry key="'Kleinfolio'" select="'CODC-B727'"/>
      <xsl:map-entry key="'Klein-Folio'" select="'CODC-B727'"/>
      <xsl:map-entry key="'Kleinfolio (?)'" select="'CODC-B727'"/>
      <xsl:map-entry key="'Klein-Oktav'" select="'CODC-B653'"/>
      <xsl:map-entry key="'Klein-Quart'" select="'CODC-B199'"/>
      <xsl:map-entry key="'Klein-Quart (nur Blatt 9)'" select="'CODC-B199'"/>
      <xsl:map-entry key="'large („maj.“) 8° format'" select="'CODC-B653'"/>
      <xsl:map-entry key="'little 4° format'" select="'CODC-B199'"/>
      <xsl:map-entry key="'little format („in 8° minori“)'" select="'CODC-B653'"/>
      <xsl:map-entry key="'oblong 4° format'" select="'CODC-B199 CODC-B978'"/>
      <xsl:map-entry key="'Octav'" select="'CODC-B653'"/>
      <xsl:map-entry key="'Oktav(?)'" select="'CODC-B653'"/>
      <xsl:map-entry key="'quart'" select="'CODC-B199'"/>
      <xsl:map-entry key="'Quartformat'" select="'CODC-B199'"/>
      <xsl:map-entry key="'Quart oder Oktav'" select="'CODC-B199 CODC-B653'"/>
      <xsl:map-entry key="'Quer-Duodez'" select="'CODC-B200 CODC-B978'"/>
      <xsl:map-entry key="'Quer-Folio'" select="'CODC-B727 CODC-B978'"/>
      <xsl:map-entry key="'Quer-Oktav'" select="'CODC-B653 CODC-B978'"/>
      <xsl:map-entry key="'Quer-Quart'" select="'CODC-B199 CODC-B978'"/>
      <xsl:map-entry key="'Registerformat'" select="'CODC-B865'"/>
      <xsl:map-entry key="'schmal.-2°'" select="'CODC-B865 CODC-B727'"/>
      <xsl:map-entry key="'schmal-4°'" select="'CODC-B865 CODC-B199'"/>
      <xsl:map-entry key="'schmal-8°'" select="'CODC-B865 CODC-B653'"/>
      <xsl:map-entry key="'Schmal-Folio'" select="'CODC-B865 CODC-B727'"/>
      <xsl:map-entry key="'Schmalquart'" select="'CODC-B865 CODC-B199'"/>
      <xsl:map-entry key="'small 4°'" select="'CODC-B199'"/>
      <xsl:map-entry key="'small 4° format'" select="'CODC-B199'"/>
      <xsl:map-entry key="'small folio format'" select="'CODC-B727'"/>
      <xsl:map-entry key="'small oblong format'" select="'CODC-B865'"/>
      <xsl:map-entry key="'Taschenformat'" select="'CODC-B234'"/>
      <xsl:map-entry key="'„in fol. minori“'" select="'CODC-B727'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="CODC-6560-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Blattzählung'" select="'CODC-D358'"/>
      <xsl:map-entry key="'Blattzählung, alte'" select="'CODC-D358'"/>
      <xsl:map-entry key="'Foliierung'" select="'CODC-D358'"/>
      <xsl:map-entry key="'Glosse'" select="'CODC-D483'"/>
      <xsl:map-entry key="'Initum (Glosse)'" select="'CODC-D483'"/>
      <xsl:map-entry key="'Kolumnenzählung'" select="'CODC-D400'"/>
      <xsl:map-entry key="'Kommentar'" select="'CODC-D483'"/>
      <xsl:map-entry key="'Lagensignatur'" select="'CODC-D387'"/>
      <xsl:map-entry key="'Lagenvermerk'" select="'CODC-D571'"/>
      <xsl:map-entry key="'Lagenzählung'" select="'CODC-D571'"/>
      <xsl:map-entry key="'Marginalien'" select="'CODC-D782'"/>
      <xsl:map-entry key="'Paginierung'" select="'CODC-D653'"/>
      <xsl:map-entry key="'Randbemerkung'" select="'CODC-D782'"/>
      <xsl:map-entry key="'Randbemerkung /'" select="'CODC-D782'"/>
      <xsl:map-entry key="'Randeintrag'" select="'CODC-D782'"/>
      <xsl:map-entry key="'Randglosse'" select="'CODC-D782'"/>
      <xsl:map-entry key="'Reklamant'" select="'CODC-D608'"/>
      <xsl:map-entry key="'Scholion'" select="'CODC-D483'"/>
      <xsl:map-entry key="'Seitentitel'" select="'CODC-D541'"/>
      <xsl:map-entry key="'Seitenzählung, alte'" select="'CODC-D653'"/>
      <xsl:map-entry key="'Spaltenzählung'" select="'CODC-D400'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="FORM-5210-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Abklatsch'" select="'FORM-E156'"/>
      <xsl:map-entry key="'aus einem anderen (gleichzeitigen) Gebet- oder Stundenbuch eingefügte Einzelblätter'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'ausgelöst'" select="'FORM-E350 FORM-F354'"/>
      <xsl:map-entry key="'ausgelöst?'" select="'FORM-E350 FORM-F354'"/>
      <xsl:map-entry key="'ausgeschnitten'" select="'FORM-E350'"/>
      <xsl:map-entry key="'beigebunden'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'beigebunden?'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'beigefügt'" select="'FORM-C102'"/>
      <xsl:map-entry key="'beigegeben'" select="'FORM-C102'"/>
      <xsl:map-entry key="'beigeheftet'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'beigelegt'" select="'FORM-C102 FORM-B456'"/>
      <xsl:map-entry key="'Beilage'" select="'FORM-C102 FORM-B456'"/>
      <xsl:map-entry key="'Beilagen'" select="'FORM-C102 FORM-B456'"/>
      <xsl:map-entry key="'beiliegend'" select="'FORM-C102 FORM-B456'"/>
      <xsl:map-entry key="'beschnitten'" select="'FORM-E947'"/>
      <xsl:map-entry key="'eingebunden'" select="'FORM-C102 FORM-B170'"/>
      <xsl:map-entry key="'eingebunden Fragment'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment, Abklatsch'" select="'FORM-X709 FORM-A890 FORM-E350 FORM-E156'"/>
      <xsl:map-entry key="'Fragment, teilweise'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragmente'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment exegetische Inhalt'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'herausgelöst'" select="'FORM-E350 FORM-F354'"/>
      <xsl:map-entry key="'Leimabdruck'" select="'FORM-E156'"/>
      <xsl:map-entry key="'lose beiliegend'" select="'FORM-C102 FORM-B456'"/>
      <xsl:map-entry key="'Palimpsest'" select="'FORM-F695 FORM-A890'"/>
      <xsl:map-entry key="'Palimpsest, teilweise'" select="'FORM-F695 FORM-A890'"/>
      <xsl:map-entry key="'Palimpsest (teilweise)'" select="'FORM-F695 FORM-A890'"/>
      <xsl:map-entry key="'palimpsestiert'" select="'FORM-F695 FORM-A890'"/>
      <xsl:map-entry key="'radiert'" select="'FORM-F695 FORM-A890'"/>
      <xsl:map-entry key="'reskribiert'" select="'FORM-F695 FORM-A890'"/>
      <xsl:map-entry key="'Teilsammlung'" select="'FORM-X832 FORM-A890 FORM-B170 FORM-C187'"/>
      <xsl:map-entry key="'Transsumpt'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
      <xsl:map-entry key="'unbestimmtes Fragment'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'verloren, teilweise'" select="'FORM-E518'"/>
      <xsl:map-entry key="'verloren, überwiegend'" select="'FORM-E518'"/>
      <xsl:map-entry key="'vorgebunden'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'vorgebunden?'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'vorgeheftet'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'zerteilt'" select="'FORM-X453 FORM-A890 FORM-B170'"/>
      <xsl:map-entry key="'zwischengebunden'" select="'FORM-B170 FORM-C102'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="FORM-5230-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Akte'" select="'FORM-D888'"/>
      <xsl:map-entry key="'Beigebunden'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Beilage'" select="'FORM-C102 FORM-B456'"/>
      <xsl:map-entry key="'Brief'" select="'FORM-D359'"/>
      <xsl:map-entry key="'Briefe'" select="'FORM-D359'"/>
      <xsl:map-entry key="'Druck'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Druck / Inkunabel'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Druck (Bl. 1*)'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Drucke'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Einblattdruck'" select="'FORM-A263 FORM-B400 FORM-C187'"/>
      <xsl:map-entry key="'Einzelblatt'" select="'FORM-B400'"/>
      <xsl:map-entry key="'Fagment'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Faszikel'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel?'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 1'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 10'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 11'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 2'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 3'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 4'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 5'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 6'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 7'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 8'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel 9'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel I'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel I - Äußeres'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel II'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel II - Äußeres'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel III'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel IV'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel IX'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel V'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel VI'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel VII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel VIII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel X'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XI'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XIII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XIV'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XIX'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XV'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XVI'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XVII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XVIII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XX'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XXI'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XXII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Faszikel XXIII'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Flugschrift'" select="'FORM-B400'"/>
      <xsl:map-entry key="'Fragment'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 1'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 10'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 2'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 3'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 4'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 5'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 6'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 7'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 8'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragment 9'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Fragmente'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Handschrift'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift, getilgt'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift, reskribiert'" select="'FORM-A890 FORM-F695'"/>
      <xsl:map-entry key="'Handschrift / Inkunabel / Druck'" select="'FORM-A890 FORM-A263'"/>
      <xsl:map-entry key="'Handschrift (Faszikel I)'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Handschrift (Faszikel II)'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Handschrift (Teil I)'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift (Teil II)'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift (Teil III)'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift 0'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift Druck'" select="'FORM-A890 FORM-A263'"/>
      <xsl:map-entry key="'Handschrift und Druck'" select="'FORM-A890 FORM-A263'"/>
      <xsl:map-entry key="'Handschrift und Text'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Htandschrift'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Konvolut'" select="'FORM-C102'"/>
      <xsl:map-entry key="'Palimpsest'" select="'FORM-A890 FORM-F695'"/>
      <xsl:map-entry key="'Postkarte'" select="'FORM-D359 FORM-A890'"/>
      <xsl:map-entry key="'Sammelhandschrift'" select="'FORM-X832 FORM-A890 FORM-B170 FORM-C187'"/>
      <xsl:map-entry key="'Schriftmusterblatt'" select="'FORM-X451 FORM-A890 FORM-B400 FORM-C187'"/>
      <xsl:map-entry key="'Urkunde'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
      <xsl:map-entry key="'Urkunde / Brief'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
      <xsl:map-entry key="'Zusammengesetzte Handschrift'" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="FORM-5240-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Fragmente'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Codex discissus'" select="'FORM-X453 FORM-A890 FORM-B170'"/>
      <xsl:map-entry key="'Transsumpt'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
      <xsl:map-entry key="'Urkunde'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
      <xsl:map-entry key="'Urkundenkonzept'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
      <xsl:map-entry key="'Abklatsch'" select="'FORM-E156'"/>
      <xsl:map-entry key="'Akte'" select="'FORM-D888'"/>
      <xsl:map-entry key="'Akten, Autographen'" select="'FORM-D888 FORM-A890'"/>
      <xsl:map-entry key="'Autograph'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph, Druck'" select="'FORM-A890 FORM-A263'"/>
      <xsl:map-entry key="'Autograph, Mitschriften'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph, teilweise'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph?'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph? / Teilautograph?'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph / Teilautograph'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph / Teilautograph?'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph.'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph(?)'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph (?)'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autograph (teilweise)'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autographen'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autographen, Drucke'" select="'FORM-A890 FORM-A263'"/>
      <xsl:map-entry key="'Brief'" select="'FORM-A890 FORM-D359'"/>
      <xsl:map-entry key="'Briefkopie / Briefentwurf'" select="'FORM-A890 FORM-D359'"/>
      <xsl:map-entry key="'Druck'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Druckabschrift'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Drucke'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Druckfahnen'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Druckmanuskript'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Druckvorlage'" select="'FORM-A890'"/>
      <xsl:map-entry key="'durchschossene Druckschrift'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Einblattdruck'" select="'FORM-A263 FORM-B400 FORM-C187'"/>
      <xsl:map-entry key="'Exemplar cum additionibus'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Handschrift'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Inkunabel'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Leimabdruck'" select="'FORM-E156'"/>
      <xsl:map-entry key="'Palimpsest'" select="'FORM-A890 FORM-F695'"/>
      <xsl:map-entry key="'Teilautograph'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Teilautograph?'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Ungebunden in Pappschuber'" select="'FORM-B456'"/>
      <xsl:map-entry key="'Verhörprotokoll'" select="'FORM-A890 FORM-D888'"/>
      <xsl:map-entry key="'Vertragskonzept'" select="'FORM-A890 FORM-D888'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="FORM-5300-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'beigebunden'" select="'FORM-B170 FORM-C102'"/>
      <xsl:map-entry key="'Einblattdruck'" select="'FORM-A263 FORM-B400 FORM-C187'"/>
      <xsl:map-entry key="'Einblattholzschnitt &gt;&gt;&gt; Einblattdruck'" select="'FORM-A263 FORM-B400 FORM-C187'"/>
      <xsl:map-entry key="'Leimabdruck'" select="'FORM-E156'"/>
      <xsl:map-entry key="'Pergamentdruck'" select="'FORM-A263'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="FORM-6560-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Autograph'" select="'FORM-A890'"/>
      <xsl:map-entry key="'autographe Notiz'" select="'FORM-A890'"/>
      <xsl:map-entry key="'autographer Eintrag'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Autographer Eintrag'" select="'FORM-A890'"/>
      <xsl:map-entry key="'autographer Vorspann'" select="'FORM-A890'"/>
      <xsl:map-entry key="'Brief'" select="'FORM-A890 FORM-D359'"/>
      <xsl:map-entry key="'Druck'" select="'FORM-A263'"/>
      <xsl:map-entry key="'Fragment'" select="'FORM-X709 FORM-A890 FORM-E350'"/>
      <xsl:map-entry key="'Urkunde'" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="SCRP-5704-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'Frühminuskel'" select="'SCRP-X710'"/>
      <xsl:map-entry key="'Hodegonstil'" select="'SCRP-X966'"/>
      <xsl:map-entry key="'Konstantinopolitanische Auszeichnungsschrift'" select="'SCRP-X977'"/>
      <xsl:map-entry key="'Druckminuskel (griechisch)'" select="'SCRP-X473'"/>
      <xsl:map-entry key="'Insulare Schrift'" select="'SCRP-X364'"/>
      <xsl:map-entry key="'Merowingische Schrift'" select="'SCRP-X207'"/>
      <xsl:map-entry key="'Epigraphische Auszeichnungsschrift'" select="'SCRP-X591'"/>
      <xsl:map-entry key="'Alexandrinische Auszeichnungsschrift'" select="'SCRP-X952'"/>
      <xsl:map-entry key="'Fettaugenmode'" select="'SCRP-X138'"/>
      <xsl:map-entry key="'Beta-Gamma-Stil'" select="'SCRP-X100'"/>
      <xsl:map-entry key="'Süditalienische Schriften'" select="'SCRP-X747'"/>
      <xsl:map-entry key="'Vorkarolingische Minuskelschrift'" select="'SCRP-X985'"/>
      <xsl:map-entry key="'Perlschrift'" select="'SCRP-X201'"/>
      <xsl:map-entry key="'Liturgische Majuskel'" select="'SCRP-X831'"/>
      <xsl:map-entry key="'Tironische Noten'" select="'SCRP-X881'"/>
      <xsl:map-entry key="'Kyrillische Schrift'" select="'SCRP-X769'"/>
      <xsl:map-entry key="'Bibelmajuskel'" select="'SCRP-X882'"/>
      <xsl:map-entry key="'Capitalis'" select="'SCRP-X892'"/>
      <xsl:map-entry key="'Salentinische Schrift'" select="'SCRP-X383'"/>
      <xsl:map-entry key="'Halbunziale'" select="'SCRP-X477'"/>
      <xsl:map-entry key="'Gelehrtenschrift'" select="'SCRP-X140'"/>
      <xsl:map-entry key="'Humanistische Schrift'" select="'SCRP-X796'"/>
      <xsl:map-entry key="'Alexandrinische Majuskel'" select="'SCRP-X294'"/>
      <xsl:map-entry key="'Visigothica'" select="'SCRP-X942'"/>
      <xsl:map-entry key="'Karolingische Minuskel'" select="'SCRP-X225'"/>
      <xsl:map-entry key="'Glagolitische Schrift'" select="'SCRP-X997'"/>
      <xsl:map-entry key="'Römische Kursive'" select="'SCRP-X599'"/>
      <xsl:map-entry key="'Sephardische Schrift'" select="'SCRP-X863'"/>
      <xsl:map-entry key="'Unziale'" select="'SCRP-X969'"/>
      <xsl:map-entry key="'Kurrente'" select="'SCRP-X937'"/>
      <xsl:map-entry key="'Beneventana'" select="'SCRP-X219'"/>
      <xsl:map-entry key="'Metochistes-Stil'" select="'SCRP-X617'"/>
      <xsl:map-entry key="'Aschkenasische Schrift'" select="'SCRP-X259'"/>
      <xsl:map-entry key="'Gotische Schrift'" select="'SCRP-X269'"/>
      <xsl:map-entry key="'Minuskel „bouletée“'" select="'SCRP-X448'"/>
      <xsl:map-entry key="'Zypriotische Schrift'" select="'SCRP-X484'"/>
      <xsl:map-entry key="'Spitzbogenmajuskel'" select="'SCRP-X196'"/>
      <xsl:map-entry key="'„Ephraim-Typ“'" select="'SCRP-X168'"/>
      <xsl:map-entry key="'„Collezione-filosofica“-Typ'" select="'SCRP-X811'"/>
      <xsl:map-entry key="'eckige Frühminuskel'" select="'SCRP-X580'"/>
      <xsl:map-entry key="'geneigte Frühminuskel'" select="'SCRP-X693'"/>
      <xsl:map-entry key="'Minuskel „tipo Anastasio“'" select="'SCRP-X561'"/>
      <xsl:map-entry key="'„Baanes-Typ“'" select="'SCRP-X978'"/>
      <xsl:map-entry key="'runde Frühminuskel'" select="'SCRP-X845'"/>
      <xsl:map-entry key="'(mehr oder weniger) viereckige Frühminuskel'" select="'SCRP-X367'"/>
      <xsl:map-entry key="'Insulare Minuskel'" select="'SCRP-X872'"/>
      <xsl:map-entry key="'Rossano-Stil'" select="'SCRP-X400'"/>
      <xsl:map-entry key="'Minuskel „Scuola Niliana“'" select="'SCRP-X628'"/>
      <xsl:map-entry key="'„Skylitzes-Typ“'" select="'SCRP-X730'"/>
      <xsl:map-entry key="'Minuskel „as de pique“'" select="'SCRP-X702'"/>
      <xsl:map-entry key="'Reggio-Stil'" select="'SCRP-X839'"/>
      <xsl:map-entry key="'Rätische Minuskel'" select="'SCRP-X263'"/>
      <xsl:map-entry key="'Alemannische Minuskel'" select="'SCRP-X101'"/>
      <xsl:map-entry key="'Capitalis quadrata'" select="'SCRP-X943'"/>
      <xsl:map-entry key="'Capitalis rustica'" select="'SCRP-X885'"/>
      <xsl:map-entry key="'otrantinische Barockminuskel'" select="'SCRP-X935'"/>
      <xsl:map-entry key="'rechteckige otrantinische Schrift'" select="'SCRP-X826'"/>
      <xsl:map-entry key="'Humanistische Minuskel'" select="'SCRP-X922'"/>
      <xsl:map-entry key="'Humanistische Kursive'" select="'SCRP-X608'"/>
      <xsl:map-entry key="'Frühkarolingische Minuskel'" select="'SCRP-X825'"/>
      <xsl:map-entry key="'Spätkarolingische Minuskel'" select="'SCRP-X645'"/>
      <xsl:map-entry key="'Diplomatische Minuskel'" select="'SCRP-X549'"/>
      <xsl:map-entry key="'Runde Glagoliza'" select="'SCRP-X576'"/>
      <xsl:map-entry key="'Jüngere Eckige Glagoliza'" select="'SCRP-X758'"/>
      <xsl:map-entry key="'Sütterlin'" select="'SCRP-X856'"/>
      <xsl:map-entry key="'Gotische Minuskel'" select="'SCRP-X648'"/>
      <xsl:map-entry key="'Halbkursive'" select="'SCRP-X698'"/>
      <xsl:map-entry key="'Gotische Kursive'" select="'SCRP-X341'"/>
      <xsl:map-entry key="'Hybrida'" select="'SCRP-X627'"/>
      <xsl:map-entry key="'Bastarda'" select="'SCRP-X255'"/>
      <xsl:map-entry key="'„Chypriote bouclée“'" select="'SCRP-X786'"/>
      <xsl:map-entry key="'„Chypriote carrée“'" select="'SCRP-X232'"/>
      <xsl:map-entry key="'„Style ‚epsilon‘ à pseudo-ligatures basses“'" select="'SCRP-X715'"/>
      <xsl:map-entry key="'Geneigte Spitzbogenmajuskel'" select="'SCRP-X672'"/>
      <xsl:map-entry key="'Senkrechte Spitzbogenmajuskel'" select="'SCRP-X489'"/>
      <xsl:map-entry key="'Cancelleresca'" select="'SCRP-X631'"/>
      <xsl:map-entry key="'Schrägovaler Stil'" select="'SCRP-X859'"/>
      <xsl:map-entry key="'Textualis'" select="'SCRP-X248'"/>
      <xsl:map-entry key="'Praegothica'" select="'SCRP-X610'"/>
      <xsl:map-entry key="'Jüngere gotische Kursive'" select="'SCRP-X483'"/>
      <xsl:map-entry key="'Ältere gotische Kursive'" select="'SCRP-X637'"/>
      <xsl:map-entry key="'Kanzleibastarda'" select="'SCRP-X423'"/>
      <xsl:map-entry key="'Bastarda, französische'" select="'SCRP-X553'"/>
      <xsl:map-entry key="'Bastarda, schleifenlos'" select="'SCRP-X565'"/>
      <xsl:map-entry key="'Südliche Textualis'" select="'SCRP-X357'"/>
      <xsl:map-entry key="'Nördliche Textualis'" select="'SCRP-X824'"/>
      <xsl:map-entry key="'Frühgotische Minuskel'" select="'SCRP-X950'"/>
      <xsl:map-entry key="'Karolingisch-gotische Übergangsschrift'" select="'SCRP-X128'"/>
      <xsl:map-entry key="'Anglicana'" select="'SCRP-X334'"/>
      <xsl:map-entry key="'Semitextualis'" select="'SCRP-X744'"/>
      <xsl:map-entry key="'Littera Bononiensis'" select="'SCRP-X788'"/>
      <xsl:map-entry key="'Rotunda'" select="'SCRP-X980'"/>
      <xsl:map-entry key="'Littera Parisiensis'" select="'SCRP-X867'"/>
      <xsl:map-entry key="'Textura'" select="'SCRP-X284'"/>
      <xsl:map-entry key="'Urkundenschrift'" select="'SCRP-E778'"/>
      <xsl:map-entry key="'Geschäftsschrift'" select="'SCRP-E405'"/>
      <xsl:map-entry key="'Buchschrift'" select="'SCRP-E859'"/>
      <xsl:map-entry key="'Sonstiger Anwendungsbereich'" select="'SCRP-E815'"/>
      <xsl:map-entry key="'Auszeichnungsschrift'" select="'SCRP-E133'"/>
      <xsl:map-entry key="'Hebräische Schrift'" select="'SCRP-A475'"/>
      <xsl:map-entry key="'Lateinische Schrift'" select="'SCRP-A755'"/>
      <xsl:map-entry key="'Slawische Schrift'" select="'SCRP-A384'"/>
      <xsl:map-entry key="'Griechische Schrift'" select="'SCRP-A219'"/>
      <xsl:map-entry key="'Geheimschrift'" select="'SCRP-A372'"/>
      <xsl:map-entry key="'Sonstiges Schriftalphabet'" select="'SCRP-A576'"/>
      <xsl:map-entry key="'Deutsche Schrift'" select="'SCRP-A338'"/>
      <xsl:map-entry key="'mimetische Ausführung'" select="'SCRP-D266'"/>
      <xsl:map-entry key="'hoher Sorgfaltsgrad'" select="'SCRP-D823'"/>
      <xsl:map-entry key="'archaisierende Ausführung'" select="'SCRP-D338'"/>
      <xsl:map-entry key="'geringer Sorgfaltsgrad'" select="'SCRP-D676'"/>
      <xsl:map-entry key="'Minuskelschrift'" select="'SCRP-B155'"/>
      <xsl:map-entry key="'Majuskelschrift'" select="'SCRP-B884'"/>
      <xsl:map-entry key="'Zwischenform zwischen Minuskel- und Majuskelschrift'" select="'SCRP-B387'"/>
      <xsl:map-entry key="'kursive Schrift'" select="'SCRP-C439'"/>
      <xsl:map-entry key="'Zwischenform zwischen geformter und kursiver Schrift'" select="'SCRP-C245'"/>
      <xsl:map-entry key="'konstruierte Schrift'" select="'SCRP-C792'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:variable name="WRLA-5710-ValuesMap" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:map-entry key="'(nord?)bairisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'(ost)mitteldeutsch mit einigen bairischen Schreibeigentümlichkeiten.'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'(ost)oberdeutsch mit wenigen mitteldeutschen Formen.'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'Bairisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'Bairisch-österreichisch'" select="'WRLA-A928'"/>
      <xsl:map-entry key="'Beginn lateinisch, sonst niederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Bietet eine Reihe lateinischer Synonyma (vorangestellt) zu einem mittelniederdeutschen Begriff.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Der Index enthält eine Liste lateinischer Deponentien, die nach Synonymgruppen geordnet und mit entsprechenden mittelniederdeutschen Übersetzungen und Anweisungen zur Rektion versehen sind.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Der Index enthält eine Liste lateinischer Verben mit ihren Komposita (das Grundwort ist tabellarisch vorangestellt, die Präfixe sind nachgeordnet) und den entsprechenden mittelniederdeutschen Übersetzungen.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Der Prolog ist mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Die mittelniederdeutschen Lemmata repräsentieren einen Sprachstand zwischen &quot;südöstlichem Westfälisch und südwestlichem Ostfälisch&quot; (Vocabularius Ex quo 1, 98).'" select="'WRLA-A243'"/>
      <xsl:map-entry key="'Für die Mundart bemerkenswert o statt a, z. B. nohesten, statt ou: vroden, statt u: ont usw., wohl mitteldeutsch'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'Grundtext der Disticha Catonis lateinisch, Schreibsprache mittelniederdeutsch (ostfälisch) mit einzelnen oberdeutschen Worten (Baldzuhn, Schulbücher im Trivium des Mittelalters (siehe oben), Bd. 1, 169).'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Halberstädter Platt'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Hand I.: schwäbisch-ostfränkisch mit bairisch-österreichischen Schreibeigentümlichkeiten (nach Kratochwill, Michel Beheim, 1977 [vgl. Tabelle S. 112f.] Beheim-Schreibvariante I-III);'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'Hand II.: bairisch.'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'Helmst. 389 ist sehr wahrscheinlich ein westfälischer Text, eventuell aus dem Grenzgebiet mit dem Nordniederdeutschen (Langbroek, Die Sprache [siehe unten], 209).'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'Hessisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'Hochdeutsch mit ripuarischen Beimischungen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'Hochdeutsch und lateinisch'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'Hochdeutsch'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'Hochdeutsche Schriftsprache der Zeit und lateinische Sprache'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'Hochdeutsche Sprache.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'Hochdeutschen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'IJsselländisch'" select="'WRLA-A405'"/>
      <xsl:map-entry key="'In einigen Lemmata niederdeutsche Glossen.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'In lateinisch-mittelniederdeutscher Mischpoesie abgefasst.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Latein, Mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Lateinisch und Mischdeutsch (nieder- und mittelfränkisch)'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'Lateinisch und Mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Lateinisch und ripuarisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'Lateinischer Text mit niederdeutschen Synonymen.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Lemmata lateinisch, Worterklärungen lateinisch und mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Lemmata mittelniederdeutsch, Worterklärungen lateinisch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Mit Ausnahme der Datierung Schreibsprache mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Mit niederdeutschen Synonyma.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Mittelbairisch mit Tendenz nach Schwaben'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'Mittelbairisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'Mitteldeutsch'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'Mittelniederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Mundart: Nr. 1 oberdeutsch, Nr. 2 und 3 rheinfränkisch'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'Mundart: niederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Mundart: ripuarisch (Blankenheimer Dialekt)'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'Mundart: vorwiegend moselfränkisch.'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'Niederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Nordbairisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'Oberdeutsch'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'Oberdeutsche Mundart'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'Oberdeutschen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'Oberrheinisch mit wenigen aüdalemannlischen Elementen'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'Ostfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'Ostfälisch.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'Ostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'Ostwestfälisch'" select="'WRLA-A469'"/>
      <xsl:map-entry key="'Paderbornisch'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'Schreibsprache des Haupttextes mittelniederdeutsch (ostfälisch), die zu kommentierenden Passagen des Hohen Liedes zuerst in lateinischer Sprache (wie auch sämtliche Rubriken), danach in mittelniederdeutscher Übersetzung anzitiert.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache frühneuhochdeutsch mit niederdeutschen Elementen.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache mittelhochdeutsch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'Schreibsprache mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: 1r Ostfälisch.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache: 1r–14r zumeist ostfälisch.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache: Ein „westlich orientiertes Nordmittelniederdeutsch“ (Derendorf, siehe unten, 10).'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'Schreibsprache: Liedinitium mitteldeutsch (301r).'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch (ostfälisch), Registerlemmata lateinisch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch (ostfälisch), mit lateinischen Rubriken.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch (ostfälisch).'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch 1r, Ostfälisch 243v–244r.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch auf Bl. 120r–122r.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch, Rubriken lateinisch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch, „die wenigen mundartlichen Besonderheiten weisen auf westliche Herkunft“ (Schmitt Seelentrost, 22*).'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: Nordmittelniederdeutsch'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'Schreibsprache: Nordmittelniederdeutsch.'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'Schreibsprache: Ostfälisch'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache: Ostfälisch, Prolog lateinisch.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache: Ostfälisch.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache: Ostmitteldeutsch, gleicher Sprachstand wie das &quot;Wolfenbütteler Evangelistar&quot; Cod. Guelf. 952 Helmst.'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'Schreibsprache: Ostmitteldeutsch.'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'Schreibsprache: Rheinfränkisch.'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'Schreibsprache: Westliches Ostfälisch.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schreibsprache: Zuweilen mitteldeutsche Passagen (37r, 42v, 47r).'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'Schreibsprache: in Glossaren (103ra–124ra) Mittelniederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: niederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprache: „…mitteldeutsch mit niederdeutschen Einflüssen, thüringisch&quot; ('" select="'WRLA-A869'"/>
      <xsl:map-entry key="'Schreibsprachen lateinisch sowie mitteldeutsch mit niederdeutschen Einflüssen.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprachen mitteldeutsch (thüringisch mit einzelnen mittelniederdeutschen Elementen) und mittelniederdeutsch.'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'Schreibsprachen: Latein und Mittelniederdeutsch (379vb–383va).'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'Schreibsprachen: Latein und Ostfälisch (203r–205v).'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schriftssprache: Ostfälisch, 50r–67v Latein.'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'Schwäbisch?'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'Sprache &quot;Nordniederdeutsch&quot;'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'Sprache &quot;Nordniederdeutsch&quot;.'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'Sprache: Bl. 1--99 lateinisch, Bl. 100--177 ripuarisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'Südrheinfränkisch mit wenigen südhessischen Formen (19recto-28recto)'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'Thüringisch?'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'Zahlreiche niederdeutsche Interpretamente, durch Rubriken hervorgehoben.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'alemanisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch ((317recto/verso)'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch (28verso-42recto)'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch /'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch mit schwäbischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch mit schwäbischen Formen'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch, Rezepte teilweise mit mitteldeutschen Formen.'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch-bairisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch-elsässisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch-fränkisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch-schwäbisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch.'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch/schwäbisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch? /'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannisch?'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'alemannische'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'bairisch (Hand I)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch (Hand II-IV)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch (III.a.-b.), hochdeutsch mit wenigen spezifisch bairischen Formen (III.c.).'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch (Vorlage?) mit wenigen ostfränkischen Formen (113rectoa-151rectob)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch /'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit fränkischen Elementen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit mittel- und niederdeutschen Formen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit mitteldeutschen Einflüssen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit mitteldeutschen Formen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit mitteldeutschen und wenigen alemannischen und schwäbischen Formen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit schwäbischen Formen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit wenigen mittelfränkischen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit wenigen schwäbisch-alemannischen Formen.'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit westmitteldeutschen Merkmalen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch mit österreichischen Formen'" select="'WRLA-A928'"/>
      <xsl:map-entry key="'bairisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-ostalemannisch mit mittel- und niederdeutschen Formen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-ostalemannisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-ostfränkisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-ostschwäbisch (Augsburg)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-ostschwäbisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-schwäbisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch-österreichisch (Rassek, S. 15f.)'" select="'WRLA-A928'"/>
      <xsl:map-entry key="'bairisch-österreichisch'" select="'WRLA-A928'"/>
      <xsl:map-entry key="'bairisch? (althochdeutsch)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairisch?'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairische Mundart'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bairischen Schreibeigentümlichkeiten'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'bambergisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'beim 1. Teil hochdeutsch, beim 2. Teil lateinisch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'bodenseealemannisch'" select="'WRLA-A848'"/>
      <xsl:map-entry key="'bodenseeschwäbisch'" select="'WRLA-A848'"/>
      <xsl:map-entry key="'böhmisch'" select="'WRLA-A757'"/>
      <xsl:map-entry key="'böhmisch?'" select="'WRLA-A757'"/>
      <xsl:map-entry key="'deutsch (Niederdeutsch)'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'deutsch (teilw. niederdeutsch) u. lateinisch u. französisch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'deutsch (wohl südrheinfränkisch)'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'deutsch / bairisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'deutsch / oberdeutsch'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'elbostfälisch'" select="'WRLA-A747'"/>
      <xsl:map-entry key="'elsässisch'" select="'WRLA-A326'"/>
      <xsl:map-entry key="'elsässisch-niederalemannisch mit schwäbischem Einschlag'" select="'WRLA-A326'"/>
      <xsl:map-entry key="'elässisch'" select="'WRLA-A326'"/>
      <xsl:map-entry key="'friesisch'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'fränkisch'" select="'WRLA-A551'"/>
      <xsl:map-entry key="'fränkisch-bairisch'" select="'WRLA-A551'"/>
      <xsl:map-entry key="'hessisch mit einigen mittelfränkischen, rheinfränkischen und bairischen Formen.'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'hessisch mit thüringischen Einflüssen (Vorlage?)'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'hessisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'hessisch-thüringisch mit einigen spezifisch mittelfränkischen Formen'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'hessisch-thüringisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'hochalemannisch'" select="'WRLA-A966'"/>
      <xsl:map-entry key="'hochdeutsch (Bl. 9--33r), ripuarisch und lateinisch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit (Hand I: wenigen) spezifisch mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit (III.a.: wenigen) spezifisch mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit - bei Schreiber I. weniger häufigen -'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit bairischen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit bairischen Schreibeigentümlichkeiten'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit bairischen und wenigen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch (nieder)alemannischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch (west)schwäbisch-alemannischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch bairischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch mitteldeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch oberdeutschen (überwiegend bairischen) Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch oberdeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit einigen spezifisch westoberdeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit mundartlichen Beimischungen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit sehr wenigen mittelfränkischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit sehr wenigen spezifisch mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit sehr wenigen spezifisch westmitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch (ost)mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch alemannisch-schwäbischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch alemannischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch bairischen Eigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch bairischen Formen und Schreibeigentümlichkeiten'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch bairischen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch bairischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mittel- und oberdeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen Formen (Vorlage) und wenigen bairischen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen Formen und einigen oberdeutschen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen Formen und wenigen oberdeutschen Schreibeigentümlichkeiten'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen Formen und wenigen oberdeutschen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch mitteldeutschen, teilweise rheinfränkischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch niederdeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch oberdeutschen (bairischen) Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch oberdeutschen (überwiegend bairischen) Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch oberdeutschen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch oberdeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch oberdeutschen, teilweise bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch oberdeutschen, teilweise bairischen Schreibeigentümlichkeiten'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch ostmitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westmitteldeutschen Formen und zahlreichen oberdeutschen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westmitteldeutschen Formen, teilweise mit bairischen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westmitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westoberdeutschen (schwäbisch-alemannischen) Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westoberdeutschen (schwäbisch-alemannischen) Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westoberdeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit spezifisch westschwäbischen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen bairischen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen bairischen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen oberdeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen oberdeutschen Schreibeigentümlichkeiten'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen ostmitteldeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch (ost)mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch bairischen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch bairischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch bairischen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch bairischen und mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch mitteldeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch oberdeutschen (überwiegend alemannisch-schwäbischen) Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch oberdeutschen Formen (82recto-89verso)'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch oberdeutschen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch oberdeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch ostmitteldeutschen (schlesischen; Hand I) Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch ostmitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch westmitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen spezifisch westmitteldeutschen und alemannisch-schwäbischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit wenigen, undifferenziert oberdeutschen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit zahlreichen spezifisch (west)mitteldeutschen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit zahlreichen spezifisch bairischen Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit zahlreichen spezifisch bairischen Schreibeigentümlichkeiten und wenigen westmitteldeutschen (zum Teil rheinfränkischen) Formen.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit zahlreichen spezifisch bairischen Schreibeigentümlichkeiten'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit zahlreichen spezifisch oberdeutschen Schreibeigentümlichkeiten (Hand II).'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch mit zahlreichen spezifisch oberdeutschen Schreibeigentümlichkeiten.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch und lateinisch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch, undifferenziert'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'hochdeutsch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'lat. und deutsch. Mundart ripuarisch, Nr. 1 niederländisch'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'lateinisch % niederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'lateinisch und alemannisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'lateinisch und alemannisch-bairisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'lateinisch und hochdeutsch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'lateinisch und niederdeutsch, teilweise hochdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'lateinisch und niederfränkisch.'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'lateinisch und ripuarisch (niederländisch gefärbt).'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'lateinisch und ripuarisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'lüneburgisch'" select="'WRLA-A512'"/>
      <xsl:map-entry key="'mainfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'meißnisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'meißnisch-niederlausitzisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'mit Orientierung zum Oberdeutschen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'mit alemannischen und südrheinfränkischen Formen'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'mit bairischen Formen'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'mit bairischen Schreibeigentümlichkeiten'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'mit einigen bairischen Schreibeigentümlichkeiten'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'mit einigen ostmitteldeutschen Formen'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'mit einigen ostschwäbischen Formen'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'mit hessischen und mittelfränkischen Formen'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'mit mittelfränkischen Schreibeigentümlichkeiten'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mit mittelfränkischen und wenigen bairischen Formen'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mit ostmitteldeutschen Formen'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'mit ostmitteldeutschen und nordbairischen Formen'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'mit südbairischen Formen'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'mit südrheinfränkischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'mit wenigen bairischen Schreibeigentümlichkeiten'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'mit wenigen ostmitteldeutschen Formen'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'mit wenigen rheinfränkischen Formen'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'mit wenigen schwäbischen und westmitteldeutschen'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'mit wenigen, undifferenziert oberdeutschen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'mit westmitteldeutschen Formen'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'mittelbairisch (beide Hände)'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'mittelbairisch mit Merkmalen des Nürnbergischen'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'mittelbairisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'mittelbairisch?'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'mitteldeutsch /'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'mitteldeutsch mit bairischen Elementen'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'mitteldeutsch'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'mitteldeutsch-niederdeutsch mit oberdeutschen und ab Bl. 42recto mit - vermutlich auf den Schreiber zurückgehenden - mittelfränkischen Formen'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'mitteldeutsch-thüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'mitteldeutsch.'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'mittelfränkisch /'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch mit einigen rheinfränkischen Formen (Hand II)'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch ripuarisch, teilweise oberdeutscher Einschlag'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch, 295verso-307recto mit wenigen oberdeutschen, vermutlich auf die Vorlage zurückgehenden Formen.'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch, jedoch mit oberdeutschem Einschlag.'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch-niederdeutsch'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränkisch.'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelfränksch (ripuarisch gefärbt)'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'mittelhessisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'mittelhochdeutsch'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'mittelniederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'mittelniederfränkisch'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'mittelrheinisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'mittelripuarisch'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'moselfränkisch'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'moselfränkisch-rheinfränkisch'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'moselfränkisch-ripuarisch'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'moselfränkisch? / ripuarisch?'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'mährisch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'niederalemannisch (1recto-39verso)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch (70rectoa-89rectoa)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch mit elsässischen Formen'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch mit schwäbischen und bairischen (Vorlage?) Formen.'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch mit stärkerem mitteldeutschen Einfluß (40recto-45verso)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch mit südrheinfränkischen Formen und zahlreichen schwäbischen Schreibeigentümlichkeiten (Vorlage?)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch mit wenigen schwäbischen Formen'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch-elsässisch'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch-südrheinfränkisch'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederalemannisch.'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'niederdeutsch (Bl. 253v)'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch (ostfälisch)'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'niederdeutsch (ostfälisch).'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'niederdeutsch /'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch mit ostfälischen Eigenheiten'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch und ripuarisch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch, aber mit Worten wie: ich neben ic, nicht, --lich u. a'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch-hochdeutsche Mischsprache'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch.'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederdeutsch?'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'niederelsässisch'" select="'WRLA-A326'"/>
      <xsl:map-entry key="'niederfränkisch mit ripuarischem Einschlag (z. B. zit, zo neben to, tzeinde, laissen, ich, wer statt wie, u. a.), der gegen Schluß stärker wird'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'niederfränkisch mit ripuarischem Einschlag.'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'niederfränkisch'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'niederfränkisch, nur Anfang ripuarisch.'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'niederlausitzisch'" select="'WRLA-A449'"/>
      <xsl:map-entry key="'niederländisch mit ripuarischer Färbung'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'niederländisch, aber stark ripuarisch gefärbt'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'niederrheinisch /'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'niederrheinisch'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'niedersächsisch'" select="'WRLA-A512'"/>
      <xsl:map-entry key="'norbairisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordalemannisch'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'nordbairisch (Vorlage?)'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch (mit alemannischen Merkmalen)'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch (nürnbergisch) mit ostfränkischen Formen.'" select="'WRLA-A921'"/>
      <xsl:map-entry key="'nordbairisch (nürnbergisch).'" select="'WRLA-A921'"/>
      <xsl:map-entry key="'nordbairisch /'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch mit (ost)mitteldeutschen Formen'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch mit obersächsischen Formen'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch mit ostfränkischen Einflüssen'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch mit ostfränkischen Formen (nürnbergisch).'" select="'WRLA-A921'"/>
      <xsl:map-entry key="'nordbairisch mit ostfränkischen und ostschwäbischen Elementen'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch mit zahlreichen mittelbairischen Formen (Vorlage?).'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch-böhmisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch-oberpfälzisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch-ostfränkisch mit ostschwäbischem Einschlag'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch-ostfränkisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordbairisch?'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordböhmisch'" select="'WRLA-A705'"/>
      <xsl:map-entry key="'nordelsässisch'" select="'WRLA-A773'"/>
      <xsl:map-entry key="'nordfränkisch'" select="'WRLA-A551'"/>
      <xsl:map-entry key="'nordhessisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'nordhessisch-westthüringisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'nordmitteldeutsch'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'nordmittelfränkisch'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'nordniederdeutsch'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'nordniedersächsisch'" select="'WRLA-A512'"/>
      <xsl:map-entry key="'nordniedersächsisch?'" select="'WRLA-A512'"/>
      <xsl:map-entry key="'nordoberdeutsch / ostfränkisch mit mitteldeutschen Merkmalen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'nordostbairisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'nordostoberdeutsch'" select="'WRLA-A551'"/>
      <xsl:map-entry key="'nordostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'nordrheinfränkisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'nordschwäbisch'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'nordthüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'nordwestliches Moselfränkisch'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'nordwestmoselfränkisch'" select="'WRLA-A977'"/>
      <xsl:map-entry key="'nordwestschwäbisch'" select="'WRLA-A689'"/>
      <xsl:map-entry key="'nordwestthüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'nordwestthüringisch?'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'nordöstliches Hochalemannisch mit wenigen schwäbischen Formen'" select="'WRLA-A966'"/>
      <xsl:map-entry key="'nordöstliches Obersächsisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'nordöstliches Südalemannisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'nordöstliches? thüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'nördliches Niederdeutsch'" select="'WRLA-A496'"/>
      <xsl:map-entry key="'nördliches Obersächsisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'nördliches Ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'nördliches Ostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'nördliches Südrheinfränkisch mit wenigen oberrheinischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'nördliches Westoberdeutsch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'nördliches obersächsisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'nördliches ostfränkisch mit osthessischem und thüringischem Einschlag'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'nördliches ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'nördliches westmitteldeutsch'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'nördliches? ostfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'nürnbergisch /'" select="'WRLA-A921'"/>
      <xsl:map-entry key="'nürnbergisch'" select="'WRLA-A921'"/>
      <xsl:map-entry key="'nürnbergisch?'" select="'WRLA-A921'"/>
      <xsl:map-entry key="'oberalemannisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'oberdeutsch / mitteldeutsch'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch /'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit Merkmalen des Schwäbischen und Nordoberdeutschen [Nürnbergisch]'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit Orientierung zum Hochdeutschen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit einigen mitteldeutschen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit einigen spezifisch bairischen Formen und Schreibeigentümlichkeiten'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit mitteldeutschen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit mittelfränkischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit spezifisch (ost)mitteldeutschen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit spezifisch bairischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit spezifisch bairischen Schreibeigentümlichkeiten und wenigen schwäbischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit spezifisch bairischen Schreibeigentümlichkeiten.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit spezifisch schwäbischen Formen (Vorlage).'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit wenigen mitteldeutschen Formen (1recto-81verso )'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit wenigen mitteldeutschen Formen.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit wenigen mittelfränkischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit wenigen spezifisch alemannischen Formen (Hand I).'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit wenigen spezifisch alemannischen Formen.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit wenigen spezifisch schwäbisch-alemannischen Formen.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit zahlreichen bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit zahlreichen spezifisch alemannischen Formen.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit zahlreichen spezifisch schwäbisch-niederalemannischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch mit zum Teil spezifisch niederalemannischen Formen.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberdeutsch-mitteldeutsches Übergangsgebiet'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'oberfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'oberpfälzisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'oberpfälzisch-nordböhmisch'" select="'WRLA-A149'"/>
      <xsl:map-entry key="'oberrheinisch (niederalemannisch-elsässisch)'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch mit einigen spezifisch elsässischen Formen'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch mit mitteldeutschen Elementen'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch mit südrheinfränkischen Einsprengseln'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch-elsässisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch-rheinfränkisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch-schwäbisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch-südalemannisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch/rheinfränkisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberrheinisch?'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'oberschwäbisch'" select="'WRLA-A960'"/>
      <xsl:map-entry key="'obersächsich'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'obersächsich-thüringisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'obersächsisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'ostalemannisch'" select="'WRLA-A640'"/>
      <xsl:map-entry key="'ostalemannisch-bairisch &amp;ostalemannisch'" select="'WRLA-A640'"/>
      <xsl:map-entry key="'ostalemannisch-bairisch'" select="'WRLA-A640'"/>
      <xsl:map-entry key="'ostalemannisch-schwäbisch'" select="'WRLA-A640'"/>
      <xsl:map-entry key="'ostalemannisch-westschwäbisch'" select="'WRLA-A640'"/>
      <xsl:map-entry key="'ostbairisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'ostelbisch'" select="'WRLA-A816'"/>
      <xsl:map-entry key="'ostfriesisch'" select="'WRLA-A133'"/>
      <xsl:map-entry key="'ostfränkisch mit bairischen Formen (1rectoa-111rectoa)'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch mit mitteldeutschen Formen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch mit mitteldeutschen und niederalemannischen Formen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch mit mitteldeutschen und niederalemannischen Formen.'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch mit wenigen bairischen, vermutlich auf die Vorlage zurückgehenden Formen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch mit zahlreichen mitteldeutschen Formen.'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch mit zahlreichen ostmitteldeutschen Formen /'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch(?)'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch, Hand E mit westmitteldeutschen Formen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch-nordbairisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch-nordbairisch?'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch-ostmitteldeutsch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch-südrheinfränkisch mit mitteldeutschen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch-thüringisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch.'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfränkisch?'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'ostfälisch /'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'ostfälisch'" select="'WRLA-A253'"/>
      <xsl:map-entry key="'ostmittelbairisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'ostmittelbairisch-südböhmisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'ostmitteldeutsch (thürnigisch)'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'ostmitteldeutsch mit Orientierung zum Oberdeutschen.'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch mit Tendenz zum Hochdeutschen'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch mit den typischen Eigenarten der Deutschordensliteratur.'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch mit niederdeutschen Einflüssen'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch mit zahlreichen oberdeutschen (bairischen) Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch-ostfälisch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsch?'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostmitteldeutsche Elemente'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'ostniederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'ostoberdeutsch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'ostschweizerisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'ostschwäbisch (Augsburg)'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit bairischen Einschlägen'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit bairischen Formen'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit zahlreichen bairischen Formen und Schreibeigentümlichkeiten'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit zahlreichen bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit zahlreichen bairischen Formen'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch mit zahlreichen bairischen Formen.'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostschwäbisch?'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'ostthüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'ostwestfälisch'" select="'WRLA-A469'"/>
      <xsl:map-entry key="'ostwestfälisch?'" select="'WRLA-A469'"/>
      <xsl:map-entry key="'pfälzisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'preußisch'" select="'WRLA-A353'"/>
      <xsl:map-entry key="'rein ripuarisch'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'rhein-moselfränkisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch (Hand I)'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch mit Elementen des Schwäbischen und Ripuarischen'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch mit deutlicher Orientierung zum'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch mit elsässischen Formen (Vorlage).'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch mit geringem schwäbischen Einschlag'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch mit mittelfränkischen Formen'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch mit niederfränkischen Einschlägen'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch(?) mit niederdeutschen Einsprengseln'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch(?)'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch/hessisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch? ? niederdeutsch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinfränkisch?'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'rheinhessisch'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'rheinisch'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'rheinisch-mittelfränkisch'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'rheinmaasländisch (mit Merkmalen des Westfälischen)'" select="'WRLA-A842'"/>
      <xsl:map-entry key="'rheinmaasländisch'" select="'WRLA-A842'"/>
      <xsl:map-entry key="'ripuarisch mit moselfränk. Einschlag.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch mit niederländ. Färbung'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch mit niederländischer Beimischung.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch und lateinisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, aber mit niederdeutschem Einschlag.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, aber niederdeutsch gefärbt.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, aber niederfränkisch gefärbt'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, aber niederländisch gefärbt'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, aber niederländisch gefärbt.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, aber stark niederländisch gefärbt'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, bei der 3. hand stark niederländisch gefärbt, auch in etwa bei der 1. Hand'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, doch niederfränk. gefärbt'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, jedoch durch hochdeutsche Vorlagen stark beeinflußt.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, jedoch niederdeutsch gefärbt.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, teilweise lateinisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, teilweise mit schriftdeutschem Einschlag'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, teilweise stark niederdeutsch gefärbt, namentlich in der Sprache des Rubrikators.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, vereinzelt hochdeutsch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch, vereinzelt lateinisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch-moselfränkisch'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch-niederfränkisch gemischt'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'ripuarisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'schlesisch'" select="'WRLA-A449'"/>
      <xsl:map-entry key="'schlesisch?'" select="'WRLA-A449'"/>
      <xsl:map-entry key="'schwäbisch /'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit bairischen Formen'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit oberrheinischen (elsässischen Elementen)'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit rheinfränkischen Elementen'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit zahlreichen bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit zahlreichen bairischen Schreibeigentümlichkeiten (Vorlage).'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch mit zahlreichen bairischen Schreibeigentümlichkeiten'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch, zum Teil mit bairischen bzw. mitteldeutschen Formen.'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-alemannisch'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-bairisch'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-ostfränkisch mit bairisch-österreichischen Formen und Schreibeigentümlichkeiten (nach Kratochwill, Michel Beheim, 1977 [vgl. Tabelle S. 114] Beheim-Schreibvariante II und III) (Hand II)'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-ostfränkisch mit bairisch-österreichischen Formen und Schreibeigentümlichkeiten'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-ostfränkisch mit einigen bairischen Schreibeigentümlichkeiten (Beheim-Schreibvariante III)'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-ostfränkisch mit wenigen bairischen Schreibeigentümlichkeiten'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch-ostfränkisch mit zahlreichen bairisch-österreichischen Formen'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schwäbisch?'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'schäbisch'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'sächsisch-thüringisch'" select="'WRLA-A554'"/>
      <xsl:map-entry key="'sübairisch'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südalemannisch mit oberrheinischen und schwäbischen Elementen'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südalemannisch mit schwäbischen Elementen'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südalemannisch mit schwäbischen und bairischen Elementen'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südalemannisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südalemannisch-schwäbisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südallemanisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südbairisch /'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbairisch mit wenigen alemannischen Formen.'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbairisch'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbairisch-österreichisch (steirisch) mit niederalemannischen und wenigen westmitteldeutschen Formen (Hand D).'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbairisch-österreichisch (steirisch) mit zahlreichen niederalemannischen Formen (Vorlage?) (Hände A-C)'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbairisch-österreichisch'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbairisch?'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südbrandenburgisch'" select="'WRLA-A349'"/>
      <xsl:map-entry key="'südböhmisch'" select="'WRLA-A268'"/>
      <xsl:map-entry key="'südhessisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'südliches Mittelbairisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'südliches Mitteldeutsch mit zahlreichen bairischen Formen (Vorlage?)'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'südliches Niederalemannisch (Hand III)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'südliches Niederalemannisch mit schwäbischen Formen'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'südliches Niederalemannisch'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'südliches Ostfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'südliches Ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'südliches Ostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'südliches Schwäbisch'" select="'WRLA-A960'"/>
      <xsl:map-entry key="'südliches Westschwäbisch'" select="'WRLA-A689'"/>
      <xsl:map-entry key="'südliches oberrheinisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'südliches ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'südliches schwäbisch mit großer Nähe zum Südalemannischen'" select="'WRLA-A960'"/>
      <xsl:map-entry key="'südliches westmitteldeutsch'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'südmitteldeutsch'" select="'WRLA-A129'"/>
      <xsl:map-entry key="'südmährisch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'südmärkisch'" select="'WRLA-A349'"/>
      <xsl:map-entry key="'südniederfränkisch'" select="'WRLA-A104'"/>
      <xsl:map-entry key="'südostbairisch'" select="'WRLA-A307'"/>
      <xsl:map-entry key="'südostdeutsch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'südostfränkisch'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'südostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'südostrheinfränkisch'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südostschwäbisch mit bairischen Formen und Schreibeigentümlichkeiten'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'südrheinfränkisch (62recto)'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch (Schneider, Pseudo-Engelhart, S. XVIf.)'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit (west)schwäbischen Formen (und mittelniederländischen sowie mittelfränkischen Eigentümlichkeiten [Vorlage]).'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit Spuren der Vorlagen (Hand II. mit ostschwäbisch-bairischen Formen).'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit Tendenz zum Hochdeutschen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit Tendenz zum Hochdeutschen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit alemannischen Formen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit bairisch-schwäbischen Schreibeigentümlichkeiten'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit bairischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit bairischen Formen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit bairischen und wenigen mitteldeutschen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit mitteldeutschen (teilweise mittelfränkischen und hessischen) und wenigen oberdeutschen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit mitteldeutschen Formen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit mitteldeutschen und niederländischen Einschlägen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit mitteldeutschen und wenigen (west)schwäbisch-alemannischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit mittelfränkischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit mittelfränkischen und westmitteldeutschen Formen (Vorlage).'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit nord- und mittelbairischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit nord- und mittelbairischen Formen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit rheinfränkischen und wenigen bairischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit schwäbischen Formen (und mittelniederländischen sowie mittelfränkischen Eigentümlichkeiten [Vorlage]).'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit schwäbischen Formen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit spezifisch bairischen Formen und Schreibeigentümlichkeiten'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit spezifisch bairischen Formen und Schreibeigentümlichkeiten.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen bairisch-schwäbischen Schreibeigentümlichkeiten.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen bairischen und ostmitteldeutschen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen mitteldeutsche Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen mitteldeutschen Formen und bairischen Schreibeigentümlichkeiten'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen mitteldeutschen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen spezifisch bairischen Schreibeigentümlichkeiten'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen spezifisch niederalemannischen Formen.'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit wenigen westmitteldeutschen und alemannischen Formen'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch mit westmitteldeutschen und mittelniederländischen Eigentümlichkeiten (Vorlage).'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südrheinfränkisch?'" select="'WRLA-A399'"/>
      <xsl:map-entry key="'südschwäbisch'" select="'WRLA-A960'"/>
      <xsl:map-entry key="'südthüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'südwestalemannisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'südwestdeutsch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'südwestfälisch'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'südwestoberdeutsch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'südwestschwäbisch'" select="'WRLA-A689'"/>
      <xsl:map-entry key="'südöstliches Oberrheinisch'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'teilweise mit schwäbischem Einschlag'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'thüringisch mit mittelfränkischen und niederdeutschen Eigenheiten'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'thüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'thüringisch-fränkisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'thüringisch-hessisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'thüringisch-obersächsisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'thüringisch?'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'undifferenziertes Hochdeutsch mit wenigen spezifisch westmitteldeutschen Formen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'undifferenziertes Hochdeutsch'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'undifferenziertes Hochdeutsch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'undifferenziertes Oberdeutsch mit Orientierung zum'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'undifferenziertes Oberdeutsch mit mittelfränkischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'undifferenziertes Oberdeutsch mit wenigen mittelfränkischen Formen'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'undifferenziertes Oberdeutsch.'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'vermutlich Abschrift nach Vorlage (Cod. Pal. germ.128;s.d.) mit Orientierung zum Hochdeutschen'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'vogtländisch'" select="'WRLA-A757'"/>
      <xsl:map-entry key="'vorwiegend hochdeutsch.'" select="'WRLA-A506'"/>
      <xsl:map-entry key="'vorwiegend mittelfränkisch'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'vorwiegend niederfränkisch.'" select="'WRLA-A229'"/>
      <xsl:map-entry key="'vorwiegend oberdeutsch'" select="'WRLA-A538'"/>
      <xsl:map-entry key="'vorwiegend rheinfränkisch'" select="'WRLA-A207'"/>
      <xsl:map-entry key="'vorwiegend ripuarisch (Vorlage niederländisch).'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'vorwiegend ripuarisch'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'vorwiegend ripuarisch.'" select="'WRLA-A497'"/>
      <xsl:map-entry key="'westalemannisch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'westbairisch (Faszikel I)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'westbairisch mit wenigen schwäbischen Formen.'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'westbairisch'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'westbairsich mit wenigen schwäbischen Formen (Faszikel II)'" select="'WRLA-A523'"/>
      <xsl:map-entry key="'westfränkisch'" select="'WRLA-A551'"/>
      <xsl:map-entry key="'westfälilsch'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'westfälisch'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'westfälisch(?)'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'westfälisch-südniederländisch'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'westhessisch'" select="'WRLA-A845'"/>
      <xsl:map-entry key="'westliches Mittelbairisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'westliches Niederalemannisch (Hand I)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'westliches Niederalemannisch (elsässisch)'" select="'WRLA-A326'"/>
      <xsl:map-entry key="'westliches Niederalemannisch mit wenigen mitteldeutschen Formen.'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'westliches Oberrheinisch (elsässisch?)'" select="'WRLA-A352'"/>
      <xsl:map-entry key="'westliches Ostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'westliches Westfälisch mit ripuarischen Einflüssen'" select="'WRLA-A100'"/>
      <xsl:map-entry key="'westmittelbairisch (südl.)'" select="'WRLA-A892'"/>
      <xsl:map-entry key="'westmittelbairisch'" select="'WRLA-A892'"/>
      <xsl:map-entry key="'westmittelbairisch?'" select="'WRLA-A892'"/>
      <xsl:map-entry key="'westmitteldeutsch mit - vermutlich auf den Schreiber zurückgehenden - niederdeutschen Formen'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'westmitteldeutsch mit oberdeutschen Formen'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'westmitteldeutsch'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'westmitteldeutschen'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'westmittelfränkisch'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'westniederdeutsch'" select="'WRLA-A683'"/>
      <xsl:map-entry key="'westoberdeutsch mit westmitteldeutschen Formen'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'westoberdeutsch mit westmitteldeutschen Formen.'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'westoberdeutsch'" select="'WRLA-A317'"/>
      <xsl:map-entry key="'westschlesisch'" select="'WRLA-A449'"/>
      <xsl:map-entry key="'westschwäbisch'" select="'WRLA-A689'"/>
      <xsl:map-entry key="'westschwäbisch/ostschwäbisch mit oberrheinischen Einschlägen'" select="'WRLA-A273'"/>
      <xsl:map-entry key="'westthüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'westthüringisch?'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'wohl mittelfränkisch'" select="'WRLA-A851'"/>
      <xsl:map-entry key="'zentralschwäbisch'" select="'WRLA-A214'"/>
      <xsl:map-entry key="'zentralthüringisch'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'zum Hochdeutschen orientiertes Westmitteldeutsch mit spezifisch mittelfränkischen Formen'" select="'WRLA-A222'"/>
      <xsl:map-entry key="'österreichisch'" select="'WRLA-A928'"/>
      <xsl:map-entry key="'östliches Mittelbairisch'" select="'WRLA-A181'"/>
      <xsl:map-entry key="'östliches Niederalemannisch mit schwäbischen Formen'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'östliches Niederalemannisch mit wenigen schwäbischen Formen (1rectoa-69versob)'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'östliches Niederalemannisch mit wenigen, vermutlich auf den Schreiber zurückgehenden schwäbischen Formen.'" select="'WRLA-A940'"/>
      <xsl:map-entry key="'östliches Ostfränkisch mit bairischen Formen'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'östliches Ostfränkisch mit wenigen bairischen Schreibeigentümlichkeiten.'" select="'WRLA-A139'"/>
      <xsl:map-entry key="'östliches Ostschwäbisch'" select="'WRLA-A482'"/>
      <xsl:map-entry key="'östliches Südalemannisch'" select="'WRLA-A375'"/>
      <xsl:map-entry key="'östliches ostmitteldeutsch'" select="'WRLA-A659'"/>
      <xsl:map-entry key="'„Die sprache ist mitteldeutsch mit niederdeutschen elementen, genauer thüringisch; gelegentlich schimmert die bairisch-österreichische vorlage … durch“ (Jansen Enikels Werke, siehe unten, XX).'" select="'WRLA-A869'"/>
      <xsl:map-entry key="'„Mundart: Mischung mitteldeutsch/niederdeutsch…“, so B. Jäger, Durch reimen gute lere geben. Untersuchungen zu Überlieferung und Rezeption Freidanks im Spätmittelalter, Göppingen 1978 (Göppinger Arbeiten zur Germanistik 238), 46.'" select="'WRLA-A129'"/>
    </xsl:map>
  </xsl:variable>

  <xsl:template name="writeThesaurusFields">
    <xsl:param name="field"/>
    <xsl:param name="value"/>
    <xsl:param name="typeOfInformation"/>
    <xsl:for-each select="$value">
      <xsl:variable name="valueToTest" select="."/>
      <xsl:choose>
        <xsl:when test="$field = 'BNDG-5240'">
          <xsl:variable name="valuesReferences" select="$BNDG-5240-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
              <xsl:with-param name="typeOfInformation" select="$typeOfInformation"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'BNDG-5260'">
          <xsl:variable name="valuesReferences" select="$BNDG-5260-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
              <xsl:with-param name="typeOfInformation" select="$typeOfInformation"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'BNDG-5300'">
          <xsl:variable name="valuesReferences" select="$BNDG-5300-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
              <xsl:with-param name="typeOfInformation" select="$typeOfInformation"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'BNDG-5320'">
          <xsl:variable name="valuesReferences" select="$BNDG-5320-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
              <xsl:with-param name="typeOfInformation" select="$typeOfInformation"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'CODC-5260'">
          <xsl:choose>
            <xsl:when test="$CODC-5260-ValuesMap($valueToTest)"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="$CODC-5260-ValuesMap($valueToTest)"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Sonstiges'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'other'"/><xsl:with-param name="notation" select="'CODC-A480'"/></xsl:call-template></xsl:when>
            <xsl:when test="contains($valueToTest, 'Pergament') and contains($valueToTest, 'Papier')"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="'CODC-A800 CODC-A366'"/></xsl:call-template></xsl:when>
            <xsl:when test="contains($valueToTest, 'Papier') and contains($valueToTest, 'orientalisch')"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="'CODC-A725'"/></xsl:call-template></xsl:when>
            <xsl:when test="contains($valueToTest, 'Papier') or contains($valueToTest, 'papier')"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="'CODC-A366'"/></xsl:call-template></xsl:when>
            <xsl:when test="contains($valueToTest, 'Pergament') or contains($valueToTest, 'pergament') or contains($valueToTest, 'perg')"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="'CODC-A800'"/></xsl:call-template></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$field = 'CODC-5382'">
          <xsl:choose>
            <!-- Konkordanzwerte aus 5382 -->
            <xsl:when test="$CODC-5382-ValuesMap($valueToTest)">
              <xsl:for-each select="tokenize($CODC-5382-ValuesMap($valueToTest), ' ')">
                <xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="."/></xsl:call-template>
              </xsl:for-each>
            </xsl:when>
            <!-- Werte aus 5382norm -->
            <xsl:when test="$valueToTest = 'Duodez'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'smaller than octavo'"/><xsl:with-param name="notation" select="'CODC-B200'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'folio'"/><xsl:with-param name="notation" select="'CODC-B727'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'folio'"/><xsl:with-param name="notation" select="'CODC-B727'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Folio (?)'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'folio'"/><xsl:with-param name="notation" select="'CODC-B727'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = '&gt;Folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'larger than folio'"/><xsl:with-param name="notation" select="'CODC-B460'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'größer als Folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'larger than folio'"/><xsl:with-param name="notation" select="'CODC-B460'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'kleiner als Oktav'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'smaller than octavo'"/><xsl:with-param name="notation" select="'CODC-B200'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'kleiner als Oktav (?)'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'smaller than octavo'"/><xsl:with-param name="notation" select="'CODC-B200'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'larger than folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'larger than folio'"/><xsl:with-param name="notation" select="'CODC-B460'"/><xsl:with-param name="typeOfInformation" select="$typeOfInformation"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Oktav'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'octavo'"/><xsl:with-param name="notation" select="'CODC-B653'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Oktav (?)'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'octavo'"/><xsl:with-param name="notation" select="'CODC-B653'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'quarto'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'quarto'"/><xsl:with-param name="notation" select="'CODC-B199'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Quart'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'quarto'"/><xsl:with-param name="notation" select="'CODC-B199'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Quart (?)'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'quarto'"/><xsl:with-param name="notation" select="'CODC-B199'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Quadratformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'square'"/><xsl:with-param name="notation" select="'CODC-B742'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Querformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'oblong'"/><xsl:with-param name="notation" select="'CODC-B978'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Schmalformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'long and narrow'"/><xsl:with-param name="notation" select="'CODC-B865'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Sedez'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'smaller than octavo'"/><xsl:with-param name="notation" select="'CODC-B200'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'unterschiedliche Formate'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'other'"/><xsl:with-param name="notation" select="'CODC-B234'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: Folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'folio'"/><xsl:with-param name="notation" select="'CODC-B727'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: Oktav'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'octavo'"/><xsl:with-param name="notation" select="'CODC-B653'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: Quadratformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'square'"/><xsl:with-param name="notation" select="'CODC-B742'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: Quart'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'quarto'"/><xsl:with-param name="notation" select="'CODC-B199'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: Querformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'oblong'"/><xsl:with-param name="notation" select="'CODC-B978'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: Schmalformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'long and narrow'"/><xsl:with-param name="notation" select="'CODC-B865'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: größer als Folio'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'larger than folio'"/><xsl:with-param name="notation" select="'CODC-B460'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'ERRECHNET: kleiner als Oktav'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'smaller than octavo'"/><xsl:with-param name="notation" select="'CODC-B200'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Sonderformat'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'other'"/><xsl:with-param name="notation" select="'CODC-B234'"/></xsl:call-template></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$field = 'CODC-6560'">
          <xsl:variable name="valuesReferences" select="$CODC-6560-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'FORM-5210'">
          <xsl:variable name="valuesReferences" select="$FORM-5210-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'FORM-5230'">
          <xsl:variable name="valuesReferences" select="$FORM-5230-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'FORM-5240'">
          <xsl:choose>
            <xsl:when test="$FORM-5240-ValuesMap($valueToTest)"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="$valueToTest"/><xsl:with-param name="notation" select="$FORM-5240-ValuesMap($valueToTest)"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Sonstiges'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'other'"/><xsl:with-param name="notation" select="'FORM-X738'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'other'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'other'"/><xsl:with-param name="notation" select="'FORM-X738'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'codex'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'codex'"/><xsl:with-param name="notation" select="'FORM-X160 FORM-A890 FORM-B170 FORM-C187'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Codex'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'codex'"/><xsl:with-param name="notation" select="'FORM-X160 FORM-A890 FORM-B170 FORM-C187'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Codex zusammengesetzteHs'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'composite'"/><xsl:with-param name="notation" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'DruckHslAntl'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'printWithManuscriptParts'"/><xsl:with-param name="notation" select="'FORM-X445 FORM-A890 FORM-A263 FORM-B170'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Druck mit hsl. Anteilen'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'printWithManuscriptParts'"/><xsl:with-param name="notation" select="'FORM-X445 FORM-A890 FORM-A263 FORM-B170'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'printWithManuscriptParts'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'printWithManuscriptParts'"/><xsl:with-param name="notation" select="'FORM-X445 FORM-A890 FORM-A263 FORM-B170'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'DruckTrgbd'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'hostVolume'"/><xsl:with-param name="notation" select="'FORM-X462 FORM-A890 FORM-A263 FORM-B170'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'hostVolume'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'hostVolume'"/><xsl:with-param name="notation" select="'FORM-X462 FORM-A890 FORM-A263 FORM-B170'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Einzelblatthandschrift'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'singleSheet'"/><xsl:with-param name="notation" select="'FORM-X451 FORM-A890 FORM-B400 FORM-C187'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'singleSheet'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'singleSheet'"/><xsl:with-param name="notation" select="'FORM-X451 FORM-A890 FORM-B400 FORM-C187'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Urkunde'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'charter'"/><xsl:with-param name="notation" select="'FORM-X677 FORM-A890 FORM-B400 FORM-C187 FORM-D888'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Fragment'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'fragment'"/><xsl:with-param name="notation" select="'FORM-X709 FORM-A890 FORM-E350'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'fragment'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'fragment'"/><xsl:with-param name="notation" select="'FORM-X709 FORM-A890 FORM-E350'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Rolle'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'scroll'"/><xsl:with-param name="notation" select="'FORM-X822 FORM-A890 FORM-C187'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Rotulus'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'scroll'"/><xsl:with-param name="notation" select="'FORM-X822 FORM-A890 FORM-C187'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'scroll'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'scroll'"/><xsl:with-param name="notation" select="'FORM-X822 FORM-A890 FORM-C187'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Sammelband'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'sammelband'"/><xsl:with-param name="notation" select="'FORM-X321 FORM-A890 FORM-B170'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'sammelband'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'sammelband'"/><xsl:with-param name="notation" select="'FORM-X321 FORM-A890 FORM-B170'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Sammlung'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'collection'"/><xsl:with-param name="notation" select="'FORM-X869 FORM-A890 FORM-C102'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'collection'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'collection'"/><xsl:with-param name="notation" select="'FORM-X869 FORM-A890 FORM-C102'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'zusammengesetzteHs'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'composite'"/><xsl:with-param name="notation" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'composite'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'composite'"/><xsl:with-param name="notation" select="'FORM-X963 FORM-A890 FORM-B170 FORM-C102'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'Gegenstand'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'other'"/><xsl:with-param name="notation" select="'FORM-X738'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'Pergamentfragment auf Pappe'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'fragment'"/><xsl:with-param name="notation" select="'FORM-X709 FORM-A890 FORM-E350'"/></xsl:call-template></xsl:when>
            
            <xsl:when test="$valueToTest = 'binding'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'binding'"/></xsl:call-template></xsl:when>
            <xsl:when test="$valueToTest = 'booklet'"><xsl:call-template name="writeThesaurusField"><xsl:with-param name="field" select="$field"/><xsl:with-param name="value" select="'booklet'"/></xsl:call-template></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$field = 'FORM-5300'">
          <xsl:variable name="valuesReferences" select="$FORM-5300-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'FORM-6560'">
          <xsl:variable name="valuesReferences" select="$FORM-6560-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'SCRP-5704'">
          <xsl:variable name="valuesReferences" select="$SCRP-5704-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="$field = 'WRLA-5710'">
          <xsl:variable name="valuesReferences" select="$WRLA-5710-ValuesMap($valueToTest)"/>
          <xsl:if test="$valuesReferences">
            <xsl:call-template name="writeThesaurusField">
              <xsl:with-param name="field" select="$field"/>
              <xsl:with-param name="value" select="$valueToTest"/>
              <xsl:with-param name="notation" select="$valuesReferences"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
