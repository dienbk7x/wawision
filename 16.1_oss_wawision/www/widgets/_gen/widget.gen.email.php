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

class WidgetGenemail
{

  private $app;            //application object  
  public $form;            //store form object  
  private $parsetarget;    //target for content

  public function WidgetGenemail($app,$parsetarget)
  {
    $this->app = $app;
    $this->parsetarget = $parsetarget;
    $this->Form();
  }

  public function emailDelete()
  {
    
    $this->form->Execute("email","delete");

    $this->emailList();
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
    $this->form = $this->app->FormHandler->CreateNew("email");
    $this->form->UseTable("email");
    $this->form->UseTemplate("email.tpl",$this->parsetarget);

    $field = new HTMLInput("adresse","text","","20","","","","","","","0");
    $this->form->NewField($field);
    $this->form->AddMandatory("adresse","notempty","Pflichtfeld!",MSGADRESSE);

    $field = new HTMLInput("datum","text","","20","","","","","","","0");
    $this->form->NewField($field);

    $field = new HTMLInput("betreff","text","","20","","","","","","","0");
    $this->form->NewField($field);
    $this->form->AddMandatory("betreff","notempty","Pflichtfeld!",MSGBETREFF);

    $field = new HTMLTextarea("nachricht",20,50);   
    $this->form->NewField($field);
    $this->form->AddMandatory("nachricht","notempty","Pflichtfeld!",MSGNACHRICHT);



  }

}

?>