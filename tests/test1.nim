import unittest, xmltools, moldybread, moldybreadpkg/fedora, typetraits, moldybreadpkg/xmlhelper

suite "Test Public Types Initialization":
  echo "Test Public Types Initialization"

  setup:
    let fedora_connection = initFedoraRequest(
      pid_part="test",
      dc_values="title:Pencil;contributor:Wiley",
      auth=("admin", "password"),
      url="http://localhost",
      max_results=20,
      output_directory="/home/user/output")

  test "FedoraRequest Initialization":
    check(fedora_connection.base_url == "http://localhost")
    check(fedora_connection.max_results == 20)

suite "Test Fedora Connection Methods":
  echo "Fedora Connection Methods"
  
  setup:
    let fedora_connection = initFedoraRequest(pid_part="garbagenamespace")
  
  test "Population Works as Expected":
    doAssert(typeof(fedora_connection.populate_results()) is seq[string])

  test "Harvest Metadata":
    doAssert(typeof(fedora_connection.harvest_datastream("DC")) is Message)

  test "Harvest Metadata No Pages":
    doAssert(typeof(fedora_connection.harvest_datastream_no_pages("DC")) is Message)

suite "Parse Data XML Helper":
  echo "Parse Data XML Helper Tests"

  setup:
    let
      some_xml = """<?xml version="1.0" encoding="UTF-8"?><datastreamProfile  xmlns="http://www.fedora.info/definitions/1/0/management/"  xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.fedora.info/definitions/1/0/management/ http://www.fedora.info/definitions/1/0/datastreamProfile.xsd" pid="test:9" dsID="MODS"><dsLabel>MODS Record</dsLabel>
      <dsVersionID>MODS.5</dsVersionID>
      <dsCreateDate>2019-12-19T02:50:24.322Z</dsCreateDate>
      <dsState>A</dsState>
      <dsMIME>application/xml</dsMIME>
      <dsFormatURI></dsFormatURI>
      <dsControlGroup>X</dsControlGroup>
      <dsSize>178</dsSize>
      <dsVersionable>true</dsVersionable>
      <dsInfoType></dsInfoType>
      <dsLocation>test:9+MODS+MODS.5</dsLocation>
      <dsLocationType></dsLocationType>
      <dsChecksumType>SHA-1</dsChecksumType>
      <dsChecksum>f2e60f8860158d6d175bdd3c2710928c79a5d024</dsChecksum>
      <dsChecksumValid>true</dsChecksumValid>
      </datastreamProfile>
      """
      an_element = "dsChecksumValid"

  test "parse_data works as expected":
    assert parse_data(some_xml, an_element) == @["true"]

suite "Get Attribute of Elements Test":
  echo "Get Attribute of Elements"

  setup:
    let
      some_xml = """<rdf:RDF xmlns:fedora="info:fedora/fedora-system:def/relations-external#" xmlns:fedora-model="info:fedora/fedora-system:def/model#" xmlns:islandora="http://islandora.ca/ontology/relsext#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
      <rdf:Description rdf:about="info:fedora/test:6">
        <islandora:isPageOf rdf:resource="info:fedora/test:3"></islandora:isPageOf>
        <islandora:isSequenceNumber>2</islandora:isSequenceNumber>
        <islandora:isPageNumber>2</islandora:isPageNumber>
        <islandora:isSection>1</islandora:isSection>
        <fedora:isMemberOf rdf:resource="info:fedora/test:3"></fedora:isMemberOf>
        <fedora-model:hasModel rdf:resource="info:fedora/islandora:pageCModel"></fedora-model:hasModel>
        <islandora:generate_ocr>TRUE</islandora:generate_ocr>
        </rdf:Description>
        </rdf:RDF>"""
      an_element = "fedora-model:hasModel"
      an_attribute = "rdf:resource"

  test "get_attribute_of_element works as expected":
    assert get_attribute_of_element(some_xml, an_element, an_attribute) == @["info:fedora/islandora:pageCModel"]
