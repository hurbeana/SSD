package ssd;

import java.io.File;
import java.io.FileInputStream;
import java.net.URL;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;


public class SSD {
    private static DocumentBuilderFactory documentBuilderFactory;
    private static DocumentBuilder documentBuilder;

	public static void main(String[] args) throws Exception {
		if (args.length != 3) {
            System.err.println("Usage: java SSD <input.xml> <mod-slot.xml> <output.xml>");
            System.exit(1);
        }
	
		String inputPath = args[0];
		String modPath = args[1];
		String outputPath = args[2];
		
    
       initialize();
       transform(inputPath, modPath, outputPath);
    }
	
	private static void initialize() throws Exception {    
       documentBuilderFactory = DocumentBuilderFactory.newInstance();
       documentBuilder = documentBuilderFactory.newDocumentBuilder();
    }
	
	/**
     * Use this method to encapsulate the main logic for this example. 
     * 
     * First read in the system document. 
     * Second create a SystemHandler and an XMLReader (SAX parser)
     * Third parse the mod-slot document
     * Last get the Document from the SystemHandler and use a
     *    Transformer to print the document to the output path.
     * 
     * @param inputPath Path to the xml file to get read in.
     * @param modPath Path to the mod-slot xml file
     * @param outputPath Path to the output xml file.
     */
    private static void transform(String inputPath, String modPath, String outputPath) throws Exception {
        // Read in the data from the system xml document, created in example 1
        Document document = documentBuilder.parse(inputPath);

        // Create an input source for the mod-slot document
    	  XMLReader parser = XMLReaderFactory.createXMLReader();

        // start the actual parsing
        SystemHandler handler = new SystemHandler(document);
        parser.setContentHandler(handler);
        parser.parse(modPath);

        // get the document from the SystemHandler
        Document parsedDoc = handler.getDocument();
        DOMSource domSource = new DOMSource(parsedDoc);

        //validate
        File schemaFile = new File("resources/system.xsd");
        SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Schema schema = schemaFactory.newSchema(schemaFile);
        Validator validator = schema.newValidator();
        validator.validate(domSource);

        //store the document
        Transformer transformer = TransformerFactory.newInstance().newTransformer();
        transformer.transform(domSource, new StreamResult(new File(outputPath)));
    }


    /**
     * Prints an error message and exits with return code 1
     * 
     * @param message The error message to be printed
     */
    public static void exit(String message) {
    	System.err.println(message);
    	System.exit(1);
    }
    

}
