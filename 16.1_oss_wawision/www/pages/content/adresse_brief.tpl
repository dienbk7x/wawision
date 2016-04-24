<script type="text/javascript">
function popUpKorr(URL) {
	w = window.open(URL, "", "menubar=no,location=no,resizable=no,scrollbars=no,status=yes,width=600,height=600");
	w.focus();
	return false;
}
</script>

<style>
.adresse_brief {
	min-height: 415px;
}

.adresse_brief_left {
	width: 200px;
	float: left;
	background: #F5F5F5 none repeat scroll 0% 0%;
	height: 100vh;
}

.adresse_brief_left ul,
.adresse_brief_left ul li {
	padding: 0;
	margin: 0;
	list-style: none;
}

.adresse_brief_left ul li {
	padding: 6px 0 6px 10px;
	border-bottom: 1px solid #FFF;
	position: relative;
}

.adresse_brief_left ul li a {
	display: inline-block;
	text-align: center;
	position: absolute;
	right: 5px;
	top: 5px;
}

.adresse_brief_left ul li.anlegenAktiv {
	background: #FFF;
}

.adresse_brief_left ul li.anlegenAktiv a {
	
}

.adresse_brief_left ul li label {
	display: block;
}

.adresse_brief_left h3 {
	padding: 3px 0 0 10px;
}

.adresse_brief_tabelle {
	padding: 0px 5px 5px 5px;
	/*min-width: 896px;*/
  width:100%;
	min-height: 600px;
	float: left;
	top:-5px;
	background: #FFF;
	position: relative;
}
.adresse_brief_preview {
	padding: 10px;
	width: 326px;
	float: left;
	background: #f5f5f5;
	display: none;
	position: relative;
	height: 100vh;
}

.preview_datum {

}

.preview_headline {
	font-size: 2em;
	margin: 10px 0 10px 0;
}

.adresse_brief_preview_close {
	position: absolute;
	right: 5px;
	top: 5px;
}
.adresse_brief_preview_print {
	position: absolute;
	right: 28px;
	top: 5px;
}

.preview_ticket_nachricht {
	background: #f1f1f1;
	padding: 10px;
	margin: 0 0 10px 0;
}

table.dataTable.row-border tbody tr.aktivBrief td, 
table.dataTable.display tbody tr.aktivBrief td {
	border-bottom: 2px solid #f5f5f5 !important;
	border-top: 2px solid #f5f5f5 !important;
	background: #f5f5f5 !important;
}

table.dataTable.display tbody tr.aktivBrief>.sorting_1, 
table.dataTable.order-column.stripe tbody tr.aktivBrief>.sorting_1 {
	background: #f5f5f5 !important;	
}

table.dataTable.display tbody tr.aktivBrief td:last-child:after {
	/*
	left: 100%;
	border: solid transparent;
	content: " ";
	height: 0;
	width: 0;
	position: absolute;
	pointer-events: none;
	border-color: rgba(245, 245, 245, 0);
	border-left-color: #f5f5f5;
	border-width: 12px;
	margin-top: -9px;
	*/
}

table.dataTable.display tbody tr.aktivBrief img {
	display: none;
}

table.dataTable.display tbody tr.aktivBrief img.close {
	display: block !important;
}

ul.adresse_brief_tabelle_filter,
ul.adresse_brief_tabelle_filter li {
	padding: 0;
	margin: 0;
	list-style: none;
}

ul.adresse_brief_tabelle_filter li {
	float: left;
	margin: 0 10px 0 0;
}

.adresse_brief_anlegen {
	display: none;
}

.adresse_brief_message {
	display: none;
        margin:10px;
}

.adresse_brief_message_inner {
	position: relative;
}

.adresse_brief_message_close {
	position: absolute;
	right: 5px;
	top: 0px;
}

input[type=submit].brief_save,
input[type=submit].brief_email_send {
	/*width: 150px;*/
	/*height: 40px;*/
}

input[type=button].anlegen_close {
	background: #e77471;
	background-color: #e77471;
	/*width: 150px;*/
	/*height: 40px;*/
	float: right;
}

</style>

<script>


var ersterEintrag = [TABELLEFLAG];

$(document).ready(function() {

	var contentBreite = 912;

	$( document ).on( "click", ".toggleCheckbox", function() {

		var checkToggle = $(this).is(':checked');
		if (checkToggle) {
			$('.adresse_brief_left').find('input').attr('checked', true);
		} else {
			$('.adresse_brief_left').find('input').attr('checked', false);
		}

	});

	$( document ).on( "click", "a.deleteEintrag", function() {

		var entryData = $(this)
			.parent()
			.parent()
			.parent()
			.parent()
			.parent()
			.prev()
			.find('a');
		var entryDataDokument = entryData.attr('data-type');
			entryDataId = entryData.attr('data-id');

		if (entryDataDokument != 'dokumente' && entryDataDokument != 'wiedervorlage') {
			showMessage('Dieses Dokument kann hier nicht gelöscht werden.', 0);
			return false;
		}

		if ( confirm('Dokument wirklich löschen?') ) {

			$.ajax({
			url: 'index.php',
			data: {
				module: 'adresse',
				action: 'briefkorrdelete',
				id: entryDataId,
        typ: entryDataDokument
			},
			dataType: 'json',
			beforeSend: function() {
				App.loading.open();
			},
			success: function(data) {
				showMessage('Das Dokument wurde gelöscht.', 1);
				App.loading.close();
				fnFilterColumn8(0);
			}
		});

		} 

	});

	$( document ).on( "click", "a.previewEintrag", function() {

		// var entryData = $(this).parent().prev().text();
		// 	entryData = entryData.split('||');

		var entryData = $(this)
			.parent()
			.parent()
			.parent()
			.parent()
			.parent()
			.prev()
			.find('a');
		var entryDataDokument = entryData.attr('data-type');
			entryDataId = entryData.attr('data-id');

		$('tr').removeClass('aktivBrief');
		$(this).parent().parent().addClass('aktivBrief');

		$.ajax({
			url: 'index.php',
			data: {
				module: 'adresse',
				action: 'briefpreview',
				type: entryDataDokument,
				id: entryDataId
			},
			dataType: 'json',
			beforeSend: function() {
				App.loading.open();
			},
			success: function(data) {
				$('.adresse_brief_preview [data-type="datum"]').html(data.datum);
				$('.adresse_brief_preview [data-type="headline"]').html(data.betreff);
				$('.adresse_brief_preview [data-type="text"]').html(data.content);

				$('.adresse_brief_preview .adresse_brief_preview_print').attr('onclick', 'briefDrucken(' + entryDataId + ');');

				$('.adresse_brief_tabelle, table#adresse_brief')
					.animate({
						width: 550
					}, 500, function() {
						$('.adresse_brief_preview').show();
					});

				App.loading.close();
			}

		});

	});

	$( document ).on( "click", "a.editEintrag", function() {

		var entryData = $(this)
			.parent()
			.parent()
			.parent()
			.parent()
			.parent()
			.prev()
			.find('a');
		var entryDataDokument = entryData.attr('data-type');
			entryDataId = entryData.attr('data-id');
			// entryData = entryData.split('||');

		if (entryDataDokument != 'dokumente' && entryDataDokument != 'wiedervorlage') {
			showMessage('Dieses Dokument kann hier nicht bearbeitet werden.', 0);
			return false;
		}

		$.ajax({
			url: 'index.php',
			data: {
				module: 'adresse',
				action: 'briefbearbeiten',
        typ : entryDataDokument,
				id: entryDataId
			},
			beforeSend: function() {
				App.loading.open();
			},
			success: function(data) {

				$('.alleAnzeigen').show();

				$('.adresse_brief_anlegen').css({
					width: $('.adresse_brief_tabelle').width()
				});


				$('.adresse_brief_tabelle').find('fieldset').hide();
				$('.adresse_brief_tabelle').find('.adresse_brief_tabelle_view').hide();

				$('.adresse_brief_anlegen')
					.html(data)
					.show();

				fnFilterColumn8(0);
				App.loading.close();
			}
		});
	});

	$( document ).on( "click", ".anlegen_close", function() {
		removeAnlegen();
	});

	$('.adresse_brief_preview_print').click(function() {
	  briefDrucken();

	});


	/* CLOSE PREVIEW */
  /*
	$('.adresse_brief_preview_close').click(function() {

		$('table#adresse_brief tr').removeClass('aktivBrief');

		$('.adresse_brief_preview').fadeOut(500, function() {
			$('.adresse_brief_tabelle, table#adresse_brief').animate({
				width: 896
			}, 500, function() {

			});
		});

	});*/

	$(document).on('click', '.brief_save,', function(event) {
		event.preventDefault();
		briefSubmit('SAVE');
	});
	$(document).on('click', '.brief_pdf', function(event) {
		event.preventDefault();
		briefSubmit('PDF');
	});
	$(document).on('click', '.brief_drucken', function(event) {
		event.preventDefault();
		briefSubmit('DRUCKEN');
	});
	$(document).on('click', '.brief_email_send', function(event) {
		event.preventDefault();
		briefSubmit('EMAIL');
	});

	$(document).on('click', '.brief_save_close,', function(event) {
		event.preventDefault();
		briefSubmit('SAVE');
		removeAnlegen();
	});

	var oTableL = $('#adresse_brief').dataTable();
	oTableL.fnSort( [ [0,'desc'] ] );
  [AJAXBRIEF]
});

function briefAnlegen(type) {
	$.ajax({
		url: 'index.php',
		type: 'GET',
		data: {
			module: 'adresse',
			action: 'brieferstellen',
			type: type,
			id: [ID]
		},
		beforeSend: function() {
			App.loading.open();
			$('.adresse_brief_left ul li').removeClass('anlegenAktiv');
			$('.anlegen_' + type).addClass('anlegenAktiv');
		},
		success: function(data) {

			$('.alleAnzeigen').show();

			$('.adresse_brief_tabelle').find('fieldset').hide();
			$('.adresse_brief_tabelle').find('.adresse_brief_tabelle_view').hide();

			$('.adresse_brief_anlegen')
				.html(data)
				.show();

			App.loading.close();
			
			//$('.adresse_brief_anlegen').html(response.html());
		}
	});
}

function briefSubmit(action) {
	var formFields = $('.brief_erstellen_form').serialize();
		formFields += '&do=' + action;


	var betreff = $('input[name="betreff"]');
	var content = $('textarea[name="content"]');
	var errors = 0;

	$('.pflichtfeld').remove();

	if (betreff.val().length == 0) {
		betreff
			.after('<span class="pflichtfeld" style="color: red;">Pflichtfeld!</span>');
		errors++;
	}

	/*
	if (content.val().length == 0) {
		content
			.after('<span class="pflichtfeld" style="color: red;">Pflichtfeld!</span>');
		errors++;
	}
	*/

	if (errors > 0) {
		return false;
	}

	$.ajax({
		url: 'index.php?module=adresse&action=brief&id=[ID]',
		data: formFields,
		type: 'POST',
		dataType: 'json',
		beforeSend: function() {
			App.loading.open();
		},
		success: function(data) {

			if ( $('input[name="eintragId"]').val().length <= 0 ) {
				$('input[name="eintragId"]').val(data.statusId);
			}
			

			App.loading.close();
			if (data.status && parseInt(data.status) > 0) {
				showMessage(data.statusText, 1);
			} else {
				showMessage(data.statusText, 0);
			}

			if (typeof data.responseType != 'undefined') {
				switch(data.responseType) {
					case 'PDF':
					window.open('index.php?module=adresse&action=briefkorrpdf&id=' + data.id);
					break;
				}
			}


			if (ersterEintrag == 1) {

				window.location.reload();

			} else {
				var oTableL = $('#adresse_brief').dataTable();
				oTableL.fnFilter('%');
				oTableL.fnFilter('');
			}

		}

	});
	fnFilterColumn8(0); //BENE
	App.loading.close(); //BENE
}

function showMessage(statusText,statusType) {
	var container = $('.adresse_brief_message');
	switch(statusType) {
		case 0:
		container.addClass('error');
		break;
		case 1:
		container.addClass('info');
		break;
	}

	container.find('.adresse_brief_message_text').text(statusText);
	container.show();

        if(statusType==1)
        {
	  window.setTimeout(function() {
		closeMessage();
	  }, 3000);
        }
}

function closeMessage() {
	var container = $('.adresse_brief_message');
	container.hide();
	container.removeClass('error');
	container.removeClass('info');
	container.find('.adresse_brief_message_text').empty();
}

function removeAnlegen() {

	$('.adresse_brief_left ul li').removeClass('anlegenAktiv');
	$('.adresse_brief_anlegen').slideUp(500, function() {
		$('.adresse_brief_anlegen')
			.empty()
			.hide();
	});

	$('.adresse_brief_tabelle').find('fieldset').show();
	$('.adresse_brief_tabelle').find('.adresse_brief_tabelle_view').show();

	$('.alleAnzeigen').hide();

}

function briefDrucken(dokumentId) {

	if (!dokumentId) {
		dokumentId = $('input[name="eintragId"]').val();
	}

	$.ajax({
	  url: 'index.php',
	  type: 'GET',
	  data: 'module=adresse&action=briefdrucken&id='+dokumentId,
	  success: function(data) {

		newwin=window.open('','printwin','width=900,height=500,directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no')
		newwin.document.write('<HTML>\n<HEAD>\n')
		newwin.document.write('<TITLE>Print Page</TITLE>\n')
		newwin.document.write('</HEAD>\n')
		newwin.document.write('<BODY>\n')
		newwin.document.write(data)
		newwin.document.write('</BODY>\n')
		newwin.document.write('</HTML>\n')
		newwin.document.close()


	  },
	  error: function(e) {

	  }
	});
}

</script>

<div class="adresse_brief">
<table><tr valign="top"><td style="vertical-align:top;">
	<div class="adresse_brief_left">
		<br><h3>Kategorien</h3><br>

		<ul>
			<li class="alleAnzeigen" style="display:none; cursor: pointer;" onclick="removeAnlegen();">
                          <center><input type="button" value="Zur &Uuml;bersicht"></center>
			</li>
		</ul>

		<ul>
<!--
			<li onclick="removeAnlegen();">
				<label><input type="checkbox" name="briefFilter" class="toggleCheckbox"><span onclick="removeAnlegen();">Alle</span></label>
			</li>
-->
			<li class="anlegen_brief">
				<label><input type="checkbox" name="briefFilter" id="brief">Briefe</label>
				<a href="javascript:;" onclick="briefAnlegen('brief');"><img src="themes/new/images/icons_neu_klein.png" width="20"></a>
			</li>
			<li class="anlegen_email">
				<label><input type="checkbox" name="briefFilter" id="email">E-Mails</label>
				<a href="javascript:;" onclick="briefAnlegen('email');"><img src="themes/new/images/icons_neu_klein.png" width="20"></a>
			</li>
			<li class="anlegen_telefon">
				<label><input type="checkbox" name="briefFilter" id="telefon">Telefonate</label>
				<a href="javascript:;" onclick="briefAnlegen('telefon');"><img src="themes/new/images/icons_neu_klein.png" width="20"></a>
			</li>
			<li class="anlegen_notiz">
				<label><input type="checkbox" name="briefFilter" id="notiz">Notizen</label>
				<a href="javascript:;" onclick="briefAnlegen('notiz');"><img src="themes/new/images/icons_neu_klein.png" width="20"></a>
			</li>
			[VORWIEDERVORLAGE]
      <li class="anlegen_wiedervorlage">
				<label><input type="checkbox" name="briefFilter" id="wiedervorlage">Wiedervorlage</label>
				<a href="javascript:;" onclick="briefAnlegen('wiedervorlage');"><img src="themes/new/images/icons_neu_klein.png" width="20"></a>
			</li>
      [NACHWIEDERVORLAGE]
			<li class="anlegen_belege">
				<label><input type="checkbox" name="briefFilter" id="belege">Belege</label>
			</li>
			<!--
			<li class="anlegen_brief"><a href="javascript:;" onclick="briefAnlegen('brief');">+</a></li>
			<li class="anlegen_email"><a href="javascript:;" onclick="briefAnlegen('email');">+</a></li>
			<li class="anlegen_telefon"><a href="javascript:;" onclick="briefAnlegen('telefon');">+</a></li>
			<li class="anlegen_notiz"><a href="javascript:;" onclick="briefAnlegen('notiz');">+</a></li>
			-->
		</ul>
		<div class="adresse_brief_message" onclick="closeMessage();" style="cursor:pointer;">
			<div class="adresse_brief_message_inner">
				<div class="adresse_brief_message_text"></div>
			<!--	<a class="adresse_brief_message_close" href="javascript:;" onclick="closeMessage();">X</a>-->
			</div>
		</div>


	</div>
  </td><td style="vertical-align:top;width:100%; min-width:500px;">
	<div class="adresse_brief_tabelle">
		<fieldset>
			<legend>Filter</legend>

				<table width="" cellspacing="5">
					<tr>
					  <td><input type="checkbox" id="versendete">&nbsp;versendete</td>
					  <td><input type="checkbox" id="nichtversendete">&nbsp;nicht versendete</td>
					</tr>
				</table>

		</fieldset>
		
		<div class="adresse_brief_tabelle_view">
			[TABELLE]
		</div>

		<div class="adresse_brief_anlegen"></div>


	</div>
  </td>
[CRMTABELLE]
</tr></table>
	<div class="adresse_brief_preview">
		<a href="javascript:;" class="adresse_brief_preview_close"><img src="./themes/new/images/icon_grau.png" width="20"></a>
		<a href="javascript:;" onclick="" class="adresse_brief_preview_print"><img src="./themes/new/images/icons_druck.png" width="20"></a>
		<div data-type="datum" class="preview_datum"></div>
		<div data-type="headline" class="preview_headline"></div>
		<div data-type="text" class="preview_text"></div>
	</div>
	<div class="clear"></div>

</div>

