
<!--- do some image manipulation, we're writing this image to newsthumbnail.jpg --->

<!--- get info --->
<cfimage action="info" structname="tempimage" source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/#URL.img#" />


<!--- if image too small, make it bigger --->
<cfif tempimage.width LT 110>


	<!--- set new height --->
	<cfset variables.newheight = Round(((110) * #tempimage.height#) / #tempimage.width#)>
	
<!--- set var to use below in img tag, helps with image caching issues in the browser --->
<cfset variables.endingWidth = 110>
<cfset variables.endingHeight = variables.newheight>

	<cfimage action="resize" 
			source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/#URL.img#" 
			destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg"
			width="110" 
			height="#variables.newheight#" 
			overwrite="true" />


<!--- if image too big, make it smaller --->
<cfelseif tempimage.width GT 600>

	<!--- set new height --->
	<cfset variables.newheight = Round(((600) * #tempimage.height#) / #tempimage.width#)>
	
<!--- set var to use below in img tag, helps with image caching issues in the browser --->
<cfset variables.endingWidth = 600>
<cfset variables.endingHeight = variables.newheight>

	<cfimage action="resize" 
			source="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/#URL.img#" 
			destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg"
			width="600" 
			height="#variables.newheight#" 
			overwrite="true" />
				 

<!--- not too big or small, just rename it --->			 
<cfelse>

<!--- set var to use below in img tag, helps with image caching issues in the browser --->
<cfset variables.endingWidth = tempimage.width>
<cfset variables.endingHeight = tempimage.height>

	<cfimage  
    	action = "convert"
    	source = "F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/#URL.img#"
		destination="F:\Inetpub\wwwroot\crc_sites\marcellus\tfiles\folder#session.auth.uid#/newsthumbnail.jpg"
    	overwrite = "yes"> 

</cfif>


<!--- see if this page already has a thumbnail, if so don't add a db entry, it should already be there --->
<cfquery datasource="#datasource#" name="checkForThumb">
SELECT filename
FROM tfiles
WHERE filename = <cfqueryparam value="newsthumbnail.jpg" cfsqltype="CF_SQL_CHAR">
	AND tid = <cfqueryparam value="#session.auth.uid#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
		
<cfif checkForThumb.recordcount EQ 0>
<!--- add entry to database so this thumbnail will show up in the manage files section --->
<cfquery datasource="#datasource#">
INSERT INTO tfiles(tid, filename, linkname, filetype, filesize, showLink)
VALUES (#session.auth.uid#, 
		'newsthumbnail.jpg', 
		<cfqueryparam value="news thumbnail" cfsqltype="CF_SQL_CHAR">, 
		'jpg', 
		'100', 
		<cfqueryparam value="no" cfsqltype="CF_SQL_CHAR">)
</cfquery>
</cfif>


<cfinclude template="../header.cfm">
<cfinclude template="../navtable.cfm"><br>

<script src="/ocm_ckeditor/jcrop/jquery.min.js"></script>
<script src="/ocm_ckeditor/jcrop/jquery.Jcrop.js"></script>
<script type="text/javascript">
  jQuery(function($){

    // Create variables (in this scope) to hold the API and image size
    var jcrop_api,
        boundx,
        boundy,

        // Grab some information about the preview pane
        $preview = $('#preview-pane'),
        $pcnt = $('#preview-pane .preview-container'),
        $pimg = $('#preview-pane .preview-container img'),

        xsize = $pcnt.width(),
        ysize = $pcnt.height();
    
    console.log('init',[xsize,ysize]);
    $('#target').Jcrop({
      onChange: updatePreview,
      onSelect: updatePreview,
	  //set aspect ratio to same as pic currently is
      //aspectRatio: xsize / ysize
	  //set ratio to our preset, 110px x 110px
	  aspectRatio: 110 / 110
    },function(){
      // Use the API to get the real image size
      var bounds = this.getBounds();
      boundx = bounds[0];
      boundy = bounds[1];
      // Store the API in the jcrop_api variable
      jcrop_api = this;

      // Move the preview into the jcrop container for css positioning
      $preview.appendTo(jcrop_api.ui.holder);
    });

    function updatePreview(c)
    {
	// Our simple event handler, called from onChange and onSelect
// event handlers, as per the Jcrop invocation above.
// This function sets the values of the hidden form fields with
// the X Y coords and the dimensions of the crop mark area.
	$('#x').val(c.x);
    $('#y').val(c.y);
    $('#w').val(c.w);
    $('#h').val(c.h);
	
      if (parseInt(c.w) > 0)
      {
        var rx = xsize / c.w;
        var ry = ysize / c.h;

        $pimg.css({
          width: Math.round(rx * boundx) + 'px',
          height: Math.round(ry * boundy) + 'px',
          marginLeft: '-' + Math.round(rx * c.x) + 'px',
          marginTop: '-' + Math.round(ry * c.y) + 'px'
        });
      }
    };

  });

  //for some reason this doesn't work
  function checkCoords()
  {
    if (parseInt($('#w').val())) return true;
    alert('Please select a crop region then press submit.');
    return false;
  };

</script>
<!--- <link rel="stylesheet" href="/ocm_ckeditor/jcrop/main.css" type="text/css" /> --->
<link rel="stylesheet" href="/ocm_ckeditor/jcrop/demos.css" type="text/css" />
<link rel="stylesheet" href="/ocm_ckeditor/jcrop/jquery.Jcrop.css" type="text/css" />
<style type="text/css">

/* Apply these styles only when #preview-pane has
   been placed within the Jcrop widget */
.jcrop-holder #preview-pane {
  display: block;
  position: absolute;
  z-index: 2000;
  top: 20px;
  right: -170px;
  padding: 6px;
  
  background-color: white;


}

/* The Javascript code will set the aspect ratio of the crop
   area based on the size of the thumbnail preview,
   specified here */
#preview-pane .preview-container {
 /* width: 250px;
  height: 170px; */
  width: 110px;
  height: 110px;
  overflow: hidden;
  
  border: 1px rgba(0,0,0,.4) solid;
  
    -webkit-border-radius: 2px;
  -moz-border-radius: 2px;
  border-radius: 2px;

  -webkit-box-shadow: 1px 1px 5px 2px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: 1px 1px 5px 2px rgba(0, 0, 0, 0.2);
  box-shadow: 1px 1px 5px 2px rgba(0, 0, 0, 0.2);
}

</style>



<table width="800" border="0" cellspacing="0" cellpadding="6" class="LL BL RL TL tempeditBGcolor" align="center">
          <tr class="headercolor"> 
            <td colspan="3" class="BL" align="left"><span class="tempeditHeader">Select an image to use as a thumbnail</span></td>
          </tr>
		  
		  <!--- navbar --->
		  <tr><td bgcolor="#ffffff" class="BL noPadCell" colspan="3">
		  
		 <table border="0" cellspacing="0" cellpadding="0"><tr>
		 <td><img src="http://www.cnyric.org/images/tempedit_navbar_jumpto.gif" alt="" border="0"></td>
		 <td><a href="teditpage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_tempedit.gif" alt="" border="0"></a></td>
		  <td><a href="adminmain.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_admin.gif" alt="" border="0"></a></td><td><a href="adminAddPage.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_addpage.gif" alt="" border="0"></a></td>
		 <td><a href="../logout.cfm"><img src="http://www.cnyric.org/images/tempedit_navbar_logout.gif" alt="" border="0"></a></td>
		 </tr></table>
		 </td></tr>
		 <!--- spacer row --->
		 <!---  <tr><td height="20"></td></tr> --->
		  
		  <!--- end navbar --->
		  
<tr><td>

<div class="container">
<!--- <div class="row"> --->
<!--- <div class="span12"> --->
<!--- <div class="jc-demo-box"> --->

&nbsp;Click and drag on the image below to create a thumbnail for your news article

  <cfoutput><table border="0" cellpadding="5"><tr><td><img src="../tfiles/folder#session.auth.uid#/newsthumbnail.jpg?#RandRange(1,99)#" id="target" alt="" width="#variables.endingWidth#" height="#variables.endingHeight#" /></td></tr></table></cfoutput>

  <form action="doCropImage.cfm" method="post" onsubmit="return checkCoords();">
			<input type="hidden" id="x" name="x" />
			<input type="hidden" id="y" name="y" />
			<input type="hidden" id="w" name="w" />
			<input type="hidden" id="h" name="h" />
			<input type="hidden" name="imageFile" id="imageFile" value="newsthumbnail.jpg" />
			<input type="submit" value="Crop Image" class="gl_submit" />
		</form>
	<div>	
  <div id="preview-pane" align="center">
  Preview image
    <div class="preview-container">
      <cfoutput><img src="../tfiles/folder#session.auth.uid#/#URL.img#" class="jcrop-preview" alt="Preview" /></cfoutput>
    </div>
  </div></div>

 

<div class="clearfix"></div>

<!--- </div> --->
<!--- </div> --->
<!--- </div> --->
</div>


</td></tr></table>

<br><br><cfinclude template="../footer.cfm"></body>
</html>

