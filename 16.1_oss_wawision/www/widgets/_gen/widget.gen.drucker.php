<?php
/*
**** COPYRIGHT & LICENSE NOTICE *** DO NOT REMOVE ****
* 
* WaWision (c) embedded projects GmbH, Holzbachstrasse 4, D-86154 Augsburg, * Germany 2015 
*
* This file is licensed under the Embedded Projects General Public License *Version 3.1. 
*
* You should have received a copy of this license from your vendor and/or *along with this file; If not, please visit www.wawision.de/Lizenzhinweis 
* to obtain the text of the corresponding license version.  
*
**** END OF COPYRIGHT & LICENSE NOTICE *** DO NOT REMOVE ****
*/
?>
<?php 

class WidgetGendrucker
{

  private $app;            //application object  
  public $form;            //store form object  
  private $parsetarget;    //target for content

  public function WidgetGendrucker($app,$parsetarget)
  {
    $this->app = $app;
    $this->parsetarget = $parsetarget;
    $this->Form();
  }

  public function druckerDelete()
  {
    
    $this->form->Execute("drucker","delete");

    $this->druckerList();
  }

  function Edit()
  {
    $this->form->Edit();
  }

  function Copy()
  {
    $this->form->Copy();
  }

  public function Create()
  {
    $this->form->Create();
  }

  public function Search()
  {
    $this->app->Tpl->Set($this->parsetarget,"SUUUCHEEE");
  }

  public function Summary()
  {
    $this->app->Tpl->Set($this->parsetarget,"grosse Tabelle");
  }

  function Form()
  {
    $this->form = $this->app->FormHandler->CreateNew("drucker");
    $this->form->UseTable("drucker");
    $this->form->UseTemplate("drucker.tpl",$this->parsetarget);

    $field = new HTMLInput("name","text","","40","","","","","","","0");
    $this->form->NewField($field);
    $this->form->AddMandatory("name","notempty","Pflichfeld!",MSGNAME);

    $field = new HTMLInput("bezeichnung","text","","40","","","","","","","0");
    $this->form->NewField($field);

    $field = new HTMLCheckbox("aktiv","","","1","0");
    $this->form->NewField($field);

    $field = new HTMLSelect("art",0,"art");
    $field->AddOption('Drucker','0');
    $field->AddOption('Fax','1');
    $field->AddOption('Etikettendrucker','2');
    $this->form->NewField($field);

    $field = new HTMLSelect("format",0,"format");
    $field->AddOption('','');
    $field->AddOption('30x15 mm','30x15x3');
    $field->AddOption('50x18 mm','50x18x3');
    $field->AddOption('100x50 mm','100x50x5');
    $field->AddOption('DIN A4','DINA4');
    $field->AddOption('DIN A5','DINA5');
    $this->form->NewField($field);

    $field = new HTMLSelect("anbindung",0,"anbindung");
    $field->AddOption('Kommandozeilenbefehl','cups');
    $field->AddOption('PDF in Verzeichnis','pdf');
    $field->AddOption('Adapterbox','adapterbox');
    $field->AddOption('E-Mail','email');
    $this->form->NewField($field);

    $field = new HTMLInput("befehl","text","","40","","","","","","","0");
    $this->form->NewField($field);

    $field = new HTMLInput("tomail","text","","40","","","","","","","0");
    $this->form->NewField($field);

    $field = new HTMLInput("tomailsubject","text","","40","","","","","","","0");
    $this->form->NewField($field);

    $field = new HTMLTextarea("tomailtext",10,40);   
    $this->form->NewField($field);

    $field = new HTMLInput("adapterboxseriennummer","text","","40","","","","","","","0");
    $this->form->NewField($field);


  }

}

?>