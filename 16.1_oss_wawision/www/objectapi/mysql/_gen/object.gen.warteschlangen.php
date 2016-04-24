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

class ObjGenWarteschlangen
{

  private  $id;
  private  $warteschlange;
  private  $label;
  private  $wiedervorlage;
  private  $adresse;

  public $app;            //application object 

  public function ObjGenWarteschlangen($app)
  {
    $this->app = $app;
  }

  public function Select($id)
  {
    if(is_numeric($id))
      $result = $this->app->DB->SelectArr("SELECT * FROM warteschlangen WHERE (id = '$id')");
    else
      return -1;

$result = $result[0];

    $this->id=$result[id];
    $this->warteschlange=$result[warteschlange];
    $this->label=$result[label];
    $this->wiedervorlage=$result[wiedervorlage];
    $this->adresse=$result[adresse];
  }

  public function Create()
  {
    $sql = "INSERT INTO warteschlangen (id,warteschlange,label,wiedervorlage,adresse)
      VALUES('','{$this->warteschlange}','{$this->label}','{$this->wiedervorlage}','{$this->adresse}')"; 

    $this->app->DB->Insert($sql);
    $this->id = $this->app->DB->GetInsertID();
  }

  public function Update()
  {
    if(!is_numeric($this->id))
      return -1;

    $sql = "UPDATE warteschlangen SET
      warteschlange='{$this->warteschlange}',
      label='{$this->label}',
      wiedervorlage='{$this->wiedervorlage}',
      adresse='{$this->adresse}'
      WHERE (id='{$this->id}')";

    $this->app->DB->Update($sql);
  }

  public function Delete($id="")
  {
    if(is_numeric($id))
    {
      $this->id=$id;
    }
    else
      return -1;

    $sql = "DELETE FROM warteschlangen WHERE (id='{$this->id}')";
    $this->app->DB->Delete($sql);

    $this->id="";
    $this->warteschlange="";
    $this->label="";
    $this->wiedervorlage="";
    $this->adresse="";
  }

  public function Copy()
  {
    $this->id = "";
    $this->Create();
  }

 /** 
   Mit dieser Funktion kann man einen Datensatz suchen 
   dafuer muss man die Attribute setzen nach denen gesucht werden soll
   dann kriegt man als ergebnis den ersten Datensatz der auf die Suche uebereinstimmt
   zurueck. Mit Next() kann man sich alle weiteren Ergebnisse abholen
   **/ 

  public function Find()
  {
    //TODO Suche mit den werten machen
  }

  public function FindNext()
  {
    //TODO Suche mit den alten werten fortsetzen machen
  }

 /** Funktionen um durch die Tabelle iterieren zu koennen */ 

  public function Next()
  {
    //TODO: SQL Statement passt nach meiner Meinung nach noch nicht immer
  }

  public function First()
  {
    //TODO: SQL Statement passt nach meiner Meinung nach noch nicht immer
  }

 /** dank dieser funktionen kann man die tatsaechlichen werte einfach 
  ueberladen (in einem Objekt das mit seiner klasse ueber dieser steht)**/ 

  function SetId($value) { $this->id=$value; }
  function GetId() { return $this->id; }
  function SetWarteschlange($value) { $this->warteschlange=$value; }
  function GetWarteschlange() { return $this->warteschlange; }
  function SetLabel($value) { $this->label=$value; }
  function GetLabel() { return $this->label; }
  function SetWiedervorlage($value) { $this->wiedervorlage=$value; }
  function GetWiedervorlage() { return $this->wiedervorlage; }
  function SetAdresse($value) { $this->adresse=$value; }
  function GetAdresse() { return $this->adresse; }

}

?>