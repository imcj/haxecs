package hx.xfl.assembler;

import hx.xfl.IDOMElement;

interface IDOMElementAssembler
{
    function parse(data:Xml):IDOMElement;
}