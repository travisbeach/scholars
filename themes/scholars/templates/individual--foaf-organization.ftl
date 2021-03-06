<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for foaf:Organization individuals (extends individual.ftl in vivo)-->

<#-- Do not show the link for temporal visualization unless it's enabled -->
<style>
#visualizationTarget {
	display: none;
}
</style>
<#include "individual-setup.ftl">
<#import "lib-vivo-properties.ftl" as vp>
<#import "lib-microformats.ftl" as mf>

<#assign isAcademicDept = false />
<#if individual.mostSpecificTypes?seq_contains("Academic Department") >
	<#assign isAcademicDept = true />
</#if>
<#assign isCollegeOrSchool = false />
<#if individual.mostSpecificTypes?seq_contains("College") || individual.mostSpecificTypes?seq_contains("School") || individual.mostSpecificTypes?seq_contains("Administrative Unit")>
	<#assign isCollegeOrSchool = true />
</#if>
<#assign isJohnsonOrHotelSchool = false />
<#if individual.name?contains(" Johnson Graduate School") || individual.name?contains("Hotel Administration")>
	<#assign isJohnsonOrHotelSchool = true />
</#if>
<#assign showVisualizations = false>
<#if individual.mostSpecificTypes?seq_contains("College") || individual.mostSpecificTypes?seq_contains("School") || individual.mostSpecificTypes?seq_contains("Academic Department")>
	<#assign showVisualizations = true />
</#if>

<#--Number of labels present-->
<#if !labelCount??>
    <#assign labelCount = 0 >
</#if>
<#--Number of available locales-->
<#if !localesCount??>
	<#assign localesCount = 1>
</#if>
<#--Number of distinct languages represented, with no language tag counting as a language, across labels-->
<#if !languageCount??>
	<#assign languageCount = 1>
</#if>	
<#assign awardsGrantProp = propertyGroups.pullProperty("http://vivoweb.org/ontology/core#assigns", "${core}Grant")!>
<#if awardsGrantProp?has_content> 
    <#assign awardsGrant>
		<@p.objectProperty awardsGrantProp editable />
	</#assign>
</#if>
<#assign adminsGrantProp = propertyGroups.pullProperty("http://purl.obolibrary.org/obo/RO_0000053", "${core}AdministratorRole")!>
<#if adminsGrantProp?has_content> 
    <#assign adminsGrant>
		<@p.objectProperty adminsGrantProp editable />
	</#assign>
</#if>
<#assign facultyProp = propertyGroups.pullProperty("http://scholars.cornell.edu/ontology/hr.owl#hasPosition", "${core}Position")!>
<#if facultyProp?has_content> 
    <#assign facultyList>
		<@p.objectProperty facultyProp editable />
	</#assign>
</#if>
<#if academicOfficers?has_content>
  <#assign academicOfficerList>
		<#list academicOfficers as officer>
			<div id="academic-officer-list-title">
				${officer.positionTitle!}
			</div>
			<div id="academic-officer-list-name">
				${officer.personName!}
			</div>
			<div class="clear-both"></div>
		</#list>
  </#assign>
</#if>
<#assign webpageProp = propertyGroups.pullProperty("http://purl.obolibrary.org/obo/ARG_2000028","http://www.w3.org/2006/vcard/ns#URL")!>
<#if webpageProp?has_content && webpageProp.statements?has_content> 
    <#assign webpageStmt = webpageProp.statements?first />
	<#assign webpageLabel = webpageStmt.label! />
	<#assign webpageUrl = webpageStmt.url! />
</#if>
<#if isCollegeOrSchool>
	<#assign departmentsProp = propertyGroups.pullProperty("http://purl.obolibrary.org/obo/BFO_0000051","http://xmlns.com/foaf/0.1/Organization")!>
	<#if departmentsProp?has_content && departmentsProp.statements?has_content> 
	    <#assign subOrgs>
			<@p.objectProperty departmentsProp editable />
		</#assign>
	</#if>
</#if>
<#assign visualizationColumn >
  <#if isAcademicDept || isCollegeOrSchool >
  	<div id="visualization-column" class="col-sm-3 col-md-3 col-lg-3 scholars-container">
  </#if>
  <#if isAcademicDept || isJohnsonOrHotelSchool >
	<div id="word_cloud_icon_holder" style="display:none">
		<a href="#" id="word_cloud_trigger"><img width="145px" src="${urls.base}/themes/scholars/images/wordcloud-icon.png"/></a>
		<p>Research Keywords</p>
	</div>
	<div <#if isJohnsonOrHotelSchool >style="display:none"</#if>>
		<a href="${urls.base}/orgSAVisualization?deptURI=${individual.uri}"><img width="68%" src="${urls.base}/themes/scholars/images/person_sa.png"/></a>
		<p>Research Interests</p>
	</div>
	<div <#if isJohnsonOrHotelSchool >style="display:none"</#if>>
  		<a href="#" id="view_selection"><img width="40%" src="${urls.base}/themes/scholars/images/dept_grants.png"/></a>
		<p>Grants</p>
	</div>
  <#elseif isCollegeOrSchool && !isJohnsonOrHotelSchool>
	<div>
		<img width="40%" src="${urls.base}/themes/scholars/images/dept_grants.png"/>
		<p>Grants</p>
	</div>
	<div>
		<a id="interd_collab_trigger" class="jqModal" href="#"><img width="54%" src="${urls.base}/themes/scholars/images/interd_collab.png"/></a>
		<p>Interdepartmental<br/>CoAuthorships</p>
	</div>
	<div>
		<a id="cross_unit_collab_trigger" class="jqModal" href="#"><img width="54%" src="${urls.base}/themes/scholars/images/cross_unit_collab.png"/></a>
		<p>Cross-unit<br/>CoAuthorships</p>
	</div>
  <#else>
	<#-- Do not display anything if the individual is neither an academic department nor a college. -->
  </#if>
  <#if isAcademicDept || isCollegeOrSchool >
  	</div>
  </#if>
</#assign>
<#assign facultyDeptListColumn >
  <#if !isCollegeOrSchool && (facultyList?has_content || adminsGrant?has_content)>
	<div id="foafOrgTabs" class="col-sm-8 col-md-8 col-lg-8 scholars-container <#if !showVisualizations>scholars-container-full</#if>">
	  <#if facultyList?has_content || adminsGrant?has_content >
		<div id="scholars-tabs-container">
		  <ul id="scholars-tabs">
		    <#if facultyList?has_content ><li><a href="#tabs-1">People</a></li> </#if>
		    <#if adminsGrant?has_content ><li><a href="#tabs-2">Grants</a></li></#if>
		  </ul>
		  <#if facultyList?has_content >
			  <div id="tabs-1" class="tab-content" data="${publicationsProp!}-dude">
				<article class="property" role="article">
			    <ul id="individual-faculty" class="property-list" role="list" >
			    	${facultyList?replace(" position","")!}
				</ul>
				</article>	
			  </div>
		  </#if>
		  <#if adminsGrant?has_content || awardsGrant?has_content >
			  <div id="tabs-2"  class="tab-content">
				<article class="property" role="article">
			    <ul id="individual-grants-pi" class="property-list" role="list" >
					<li class="subclass" role="listitem">
					  <#if adminsGrant?has_content >
						<h3>Administers Grant</h3>
					    <ul class="subclass-property-list">
			    			${adminsGrant!}
						</ul>
					  </#if>
					  <#if awardsGrant?has_content >
						<h3>Awards Grant</h3>
					    <ul class="subclass-property-list">
			    			${awardsGrant!}
						</ul>
					  </#if>
					</li>
				</ul>
			  </div>
		  </#if>
		</div>
	  </#if>
	</div>
  <#elseif isCollegeOrSchool && (subOrgs?has_content || facultyList?has_content)>
	<div id="foafOrgTabs" class="col-sm-8 col-md-8 col-lg-8 scholars-container <#if !showVisualizations>scholars-container-full</#if>">
		<div id="scholars-tabs-container">
		  <ul id="scholars-tabs">
		    <#if subOrgs?has_content ><li><a href="#tabs-1">Academic Units</a></li></#if>
		    <#if facultyList?has_content ><li><a href="#tabs-1">People</a></li> </#if>
		  </ul>
			  <#if subOrgs?has_content >
				  <div id="tabs-1"  class="tab-content" data="${publicationsProp!}-dude">
					<article class="property" role="article">
				    <ul id="individual-faculty" class="property-list" role="list">
				    	${subOrgs!}
					</ul>
					</article>	
				  </div>
			  </#if>
			  <#if facultyList?has_content && !subOrgs?has_content>
				  <div id="tabs-1" class="tab-content" data="${publicationsProp!}-dude">
					<article class="property" role="article">
				    <ul id="individual-faculty" class="property-list" role="list" >
				    	${facultyList?replace(" position","")!}
					</ul>
					</article>	
				  </div>
			  </#if>
		</div>
	</div>
  <#else>
	<#-- Don't display anything if the individual is neither an academic department nor a college -->
  </#if>
</#assign>
<#-- Default individual profile page template -->
<#-- The row1 div contains the top portion of the profile page: name, photo, icon controls -->
<div id="row1" class="row scholars-row">
<div class="col-sm-12 col-md-12 col-lg-12 scholars-container" id="foafOrgMainColumn">
	<section id="individual-info" ${infoClass!} role="region">
	    <#include "individual-adminPanel.ftl">


	    <header>
	        <#if relatedSubject??>
	            <h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
	            <p><a href="${relatedSubject.url}" title="${i18n().return_to(relatedSubject.name)}">&larr; ${i18n().return_to(relatedSubject.name)}</a></p>                
	        <#else>                
	            <h1 class="fn foaf-organization" itemprop="name">
	                <#-- Label -->
	                <@p.label individual editable labelCount localesCount languageCount/>
	                <#--  Most-specific types -->
	                <@p.mostSpecificTypes individual />
	            </h1>
	        </#if>
			<div id="foaf-organization-icons">
				<#include "individual-iconControls.ftl" />
			</div>
			<h2 id="page-heading-break">  </h2>
	    </header>
		<div class="clear-both"></div>
		<div id="academic-officer-list">
			${academicOfficerList!"&nbsp;"}
		</div>
	 </section> <!-- individual-info -->
			<div class="clear-both"></div>
	</div> <!-- foafPersonMainColumn -->
</div> <!-- row1 -->

<#assign nameForOtherGroup = "${i18n().other}"> 

<#-- The row2 div contains the visualization section and the faculty or department list, separated by a "spacer" column -->
<div id="row2" class="row scholars-row foaf-organization-row2">
	<#if showVisualizations>${visualizationColumn}</#if>
	<div id="foafOrgSpacer" class="col-sm-1 col-md-1 col-lg-1"></div>
	${facultyDeptListColumn}
</div> <!-- row2 div subOrgs -->
<#if !facultyList?has_content || !adminsGrant?has_content || !subOrgs?has_content>
	<div id="foaf-organization-blank-row"></div>
</#if>

<#assign rdfUrl = individual.rdfUrl>

<#if rdfUrl??>
    <script>
        var individualRdfUrl = '${rdfUrl}';
    </script>
</#if>
<script>
    var i18nStringsUriRdf = {
        shareProfileUri: '${i18n().share_profile_uri}',
        viewRDFProfile: '${i18n().view_profile_in_rdf}',
        closeString: '${i18n().close}'
    };
	var i18nStrings = {
	    displayLess: '${i18n().display_less}',
	    displayMoreEllipsis: '${i18n().display_more_ellipsis}',
	    showMoreContent: '${i18n().show_more_content}',
	};

</script>
<script>
	$(function() {
	  $( "#scholars-tabs-container" ).tabs();
	});
    var individualLocalName = "${individual.localName}";
</script>
<script>
var i18nStrings = {
    displayLess: '${i18n().display_less}',
    displayMoreEllipsis: '${i18n().display_more_ellipsis}',
    showMoreContent: '${i18n().show_more_content}',
    verboseTurnOff: '${i18n().verbose_turn_off}',
};
var i18nStringsUriRdf = {
    shareProfileUri: '${i18n().share_profile_uri}',
    viewRDFProfile: '${i18n().view_profile_in_rdf}',
    closeString: '${i18n().close}'
};

</script>
<script>
$().ready(function() {
	if ($('#individual-faculty li').first().children('h3').text() == "academic officer") {
		$('#individual-faculty li').first().hide();
	}
});
</script>

<div id="grantsVis"></div>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/scholars-vis/keywordcloud/kwcloud.css" />')}
<div id="word_cloud_vis">

<h3 style="margin:0;padding:0">Research Keywords</h3>
	<font face="Times New Roman" size="2">
	<span><i>Click on a keyword to view the list of the relevant faculty.</i></span>
<#--	
<label class="boxLabel"><input id="keyword" type="checkbox" class="cbox" checked>Article Keywords<span id="kw">(0)</span></label>
<label class="boxLabel"><input id="mined" type="checkbox" class="cbox" checked>Inferred Keywords<span id="minedt">(0)</span></label>
<label class="boxLabel"><input id="mesh" type="checkbox" class="cbox" checked>Mesh Terms<span id="mt">(0)</span></label> 
-->
</font>

        <div id="info_icon_text" style="display:none">
          This visualization represents the scholarly fingerprints for an entire academic unit which is an aggregation of all the keywords found in all the articles authored by all faculty and researchers of a academic unit. The size of the keyword indicates the frequency of the keyword in the author’s publications which suggests that in which subject author published most (or least) frequently. This is not a static visualization. A user can click on any keyword to see the list of authors that have this keyword associated with one of more of their articles. One can click on the author’s name in the list to go to the author’s page which contains the full list of author’s publications in Scholars. Note: This information is based solely on publications that have been loaded into the system.
        </div>
</div>


${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/individual/individual-vivo.css?vers=1.5.1" />',
					'<link rel="stylesheet" href="${urls.base}/css/individual/individual.css" />')}

${headScripts.add('<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.truncator.js"></script>',
                  '<script type="text/javascript" src="${urls.base}/js/json2.js"></script>',
				  '<script type="text/javascript" src="${urls.base}/js/jquery_plugins/qtip/jquery.qtip-3.0.3.min.js"></script>',
				  '<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>')}
                  
${scripts.add('<script type="text/javascript" src="${urls.base}/js/individual/individualUtils.js?vers=1.5.1"></script>',
			  '<script type="text/javascript" src="${urls.base}/js/imageUpload/imageUploadUtils.js"></script>',
	          '<script type="text/javascript" src="${urls.base}/js/individual/moreLessController.js"></script>',
              '<script type="text/javascript" src="${urls.base}/themes/scholars/js/individualUriRdf.js"></script>')}

<script type="text/javascript">
    i18n_confirmDelete = "${i18n().confirm_delete}"
</script>
<script>
	grantsDataDepartmentUri = "${individual.uri}"
</script>


${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/scholars-vis/org-research-areas/ra.css" />',
					'<link rel="stylesheet" href="${urls.base}/css/scholars-vis/grants/style.css" />',
					'<link rel="stylesheet" href="${urls.base}/css/jquery_plugins/jquery.qtip.min.css" />',
					'<link rel="stylesheet" href="${urls.base}/css/scholars-vis/jqModal.css" />')}

<#if isCollegeOrSchool >
	${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/scholars-vis/collaborations/collab.css" />')}
</#if>
${scripts.add('<script type="text/javascript" src="${urls.base}/js/d3.min.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/scholars-vis/scholars-vis.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/scholars-vis/grants/transform-data.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/scholars-vis/grants/CustomTooltip.js"></script>',
			'<script type="text/javascript" src="${urls.base}/js/scholars-vis/collaborations/collaborations.js"></script>',
			'<script type="text/javascript" src="${urls.base}/js/scholars-vis/jqModal.js"></script>',
			'<script type="text/javascript" src="${urls.base}/js/scholars-vis/rdflib.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/scholars-vis/d3/d3-tip.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/scholars-vis/d3/d3.layout.cloud.js"></script>',
              '<script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>',
			  '<script type="text/javascript" src="${urls.base}/js/scholars-vis/wordcloud/word-cloud.js"></script>')}

<#if isCollegeOrSchool >

	<#-- TEMPORARY HACK. ONLY SHOW THE COLLAB VIZ FOR THE COLLEGE OF ENGINEERING -->
	<#if individual.nameStatement?? && individual.nameStatement.value == "College of Engineering" >
	  <div id="interd_collab_vis" class="dept_collab_vis" style="display:none">
	 	
	 	<h3 style="margin:0;padding:0">Interdepartmental CoAuthorships</h3>
		<font face="Times New Roman" size="2">
		<span><i>Click on any arc to zoom in and on the center circle to zoom out.
		Once zoomed in to a faculty of interest, click on the outer arc to view the list of coauthored publications.
		</i></span>
	 	</font>

        <div id="info_icon_text" style="display:none">
          The interdepartmental co-authorships were identified based on the affiliation data extracted from the citation of a publication. Currently, we present co-authorships between researchers with the faculty appointments only. This visualization has a zoom-in/zoom-out functionality. The visualization consists of three layers i.e., department-level layer (inner most), person-level layer 1 (i.e., author in context) and the person-level layer 2 (i.e., the co-authors). To view the co-authorships, a user is first required to select a department of interest. In this view, a user can observe, who has co-authored with whom and how often did they co-authored. To view the co-authored publications, user is required to select a faculty member of interest. In this view, clicking on a co-author (in the outer circle) displays the list of co-authored articles in the tooltip. Click in the center circle to zoom out to select any other faculty/department of interest. Note: This information is based solely on publications that have been loaded into the system. 
        </div>
	  </div>
	  <div id="cross_unit_collab_vis" class="dept_collab_vis" style="display:none">
		
		<h3 style="margin:0;padding:0">Cross-unit CoAuthorships</h3>
		<font face="Times New Roman" size="2">
		<span><i>Click on any arc to zoom in and on the center circle to zoom out.
		Once zoomed in to a faculty of interest, click on the outer arc to view the list of coauthored publications.
		</i></span>
		</font>

        <div id="info_icon_text" style="display:none">
          The cross-unit co-authorships were identified based on the affiliation data extracted from the citation of a publication. Currently, we present co-authorships between researchers with the faculty appointments only. This visualization has a zoom-in/zoom-out functionality. The visualization consists of three layers i.e., unit-level layer (inner most), person-level layer 1 (i.e., author in context) and the person-level layer 2 (i.e., the co-authors). To view the co-authorships, a user is first required to select an academic unit of interest. In this view, a user can observe, who has co-authored with whom and how often did they co-authored. To view the co-authored publications, user is required to select a faculty member of interest. In this view, clicking on a co-author (in the outer circle) displays the list of co-authored articles in the tooltip. Click in the center circle to zoom out to select any other faculty/academic unit of interest. Note: This information is based solely on publications that have been loaded into the system.
        </div>
	  </div>
		<script>
		$().ready(function() {
		  var cucs = new ScholarsVis.CrossUnitCollaborationSunburst({
		    target : '#cross_unit_collab_vis',
		    modal : true
	      });
	      $('#cross_unit_collab_trigger').click(cucs.show);
		  $('#cross_unit_collab_exporter').click(cucs.showVisData);
	
		  var idcs = new ScholarsVis.InterDepartmentCollaborationSunburst({
		    target : '#interd_collab_vis',
		    modal : true
	      });
	      $('#interd_collab_trigger').click(idcs.show);
	      $('#interd_collab_exporter').click(idcs.showVisData);
		});
		$().ready(function() {
		  new ScholarsVis.Toolbar("#cross_unit_collab_vis");
		  new ScholarsVis.Toolbar("#interd_collab_vis");
		});
		</script>
	<#else>
	  <#-- IF IT'S NOT THE COE, DISPLAY A BOGUS "NO DATA" MESSAGE -->
	  <div id="no_collaboration_data" class="jqmWindow dept_collab_vis" style="display:none;">
	 	<div style="padding:40px 40px 0 40px;">There is no collaboration data available for the ${individual.nameStatement.value!"college"} at this time.</div>
	  </div>
		<script>
		$().ready(function() {
			$('#no_collaboration_data').jqm();
		});
		</script>

	</#if>

</#if>
<#if isAcademicDept || isJohnsonOrHotelSchool >
	<script>
	$().ready(function() {
	  var wc = new ScholarsVis.DepartmentWordCloud({
	    target : '#word_cloud_vis',
	    modal : true,
	    department : "${individual.uri?url}",
	    animation : true
	    });
	  wc.examineData(function(data) {
	    if (data.length > 0) {
	      $('#word_cloud_icon_holder').show();
	      $('#word_cloud_trigger').click(wc.show);
	      $('#word_cloud_exporter').click(wc.showVisData);
	    }
	  });
      new ScholarsVis.Toolbar("#word_cloud_vis");
	});
	</script>
</#if>

</script>
