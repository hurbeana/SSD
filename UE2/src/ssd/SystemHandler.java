package ssd;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 * TODO: Implement this content handler.
 */
public class SystemHandler extends DefaultHandler {
	/**
	 * Use this xPath variable to create xPath expression that can be
	 * evaluated over the XML document.
	 */
	private static XPath xPath = XPathFactory.newInstance().newXPath();
	
	/**
	 * Store and manipulate the system XML document here.
	 */
	private Document systemDoc;
	
	/**
	 * This variable stores the text content of XML Elements.
	 */
	private String eleText;
	private String item;
	private String store;
	private String slot;


    
	
    public SystemHandler(Document doc) {
    	systemDoc = doc;
    }
    
    @Override
    /**
     * SAX calls this method to pass in character data
     */
  	public void characters(char[] text, int start, int length)
  			    throws SAXException {
  		eleText = new String(text, start, length);
  	}

    /**
     * 
     * Return the current stored system document
     * 
     * @return XML Document
     */
	public Document getDocument() {
		return systemDoc;
	}
    
  @Override
  public void startElement(String uri, String localName, String qName, Attributes attributes)
      throws SAXException {
	  if(!qName.equals("mod")) {
	    this.item = attributes.getValue("item");
      this.store = attributes.getValue("store");
      this.slot = attributes.getValue("slot");
      if (this.slot == null) {
        throw new SAXException("Couldn't find a slot attribute on " + qName + " element");
      }
    }
  }

  @Override
  public void endElement(String uri, String localName, String qName) throws SAXException {
	  if(!qName.equals("mod")) {
      System.out.println();
      System.out.println("qName: " + qName);
      System.out.println("store: " + this.slot);
      System.out.println("slot: " + this.store);
      System.out.println("value: " + eleText);

      try {
        XPathExpression xPathExpression = xPath
            .compile("//slot[@id = '" + slot + "']");
        NodeList slotBoi = (NodeList)xPathExpression.evaluate(systemDoc, XPathConstants.NODESET);

        xPathExpression = xPath.compile("boolean(//slot[@id = '" + slot + "']/" + qName + ")");
        boolean hasTarget = (Boolean)xPathExpression.evaluate(systemDoc, XPathConstants.BOOLEAN);

        for (int i = 0; i < slotBoi.getLength(); i++) {
          Node nSlot = slotBoi.item(i);
          //if(!hasTarget) {
          //  Element targetElem = systemDoc.createElement(qName);
          //  if(qName.equals("input"))
          //    nSlot.insertBefore(targetElem, nSlot.getFirstChild());
          //  else
          //    nSlot.appendChild(targetElem); //output
          //}
          xPathExpression = xPath.compile("boolean(//slot[@id = '" + slot + "']/" + qName + "/item[@id = " + item + "])");
          boolean itemExists = (Boolean)xPathExpression.evaluate(systemDoc, XPathConstants.BOOLEAN);
          System.out.println(hasTarget ? "we have target" : "no target here");
          System.out.println(itemExists ? "Item exists" : "Dosnt exist");

        }
      } catch (XPathExpressionException e) {
        e.printStackTrace();
      }

      this.item = null;
      this.slot = null;
      this.store = null;
      this.eleText = null;
    }
  }
}

