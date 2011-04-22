<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for foaf:Person individuals -->

<#include "individual-setup.ftl">
    
<section id="individual-intro" class="vcard person" role="region">

    <section id="share-contact" role="region"> 
        <#-- Image -->           
        <#assign individualImage>
            <@p.image individual=individual 
                      propertyGroups=propertyGroups 
                      namespaces=namespaces 
                      editable=editable 
                      showPlaceholder="always" 
                      placeholder="${urls.images}/placeholders/person.thumbnail.jpg" />
        </#assign>

        <#if ( individualImage?contains('<img class="individual-photo"') )>
            <#assign infoClass = 'class="withThumb"'/>
        </#if>

        <div id="photo-wrapper">${individualImage}</div>
        
        <#-- CU directory link -->    
        <#assign netid  = propertyGroups.getPropertyAndRemoveFromList("http://vivo.library.cornell.edu/ns/0.1#CornellemailnetId")!>
            <p class="contact-information"><img class="middle" src="${urls.images}/individual/contactInformationIcon.gif" alt="Contact information icon" /><a href="http://www.cornell.edu/search/?tab=people&netid=${netid}" target="_blank">Contact information</a></p>

        <nav role="navigation">
            <ul id ="individual-tools-people" role="list">
                <li role="listitem"><img title="${individual.uri}" class="middle" src="${urls.images}/individual/uriIcon.gif" alt="uri icon" /></li>
    
                <#assign rdfUrl = individual.rdfUrl>
                <#if rdfUrl??>
                    <li role="listitem"><a title="View this individual in RDF format" class="icon-rdf" href="${rdfUrl}">RDF</a></li>
                </#if>
            </ul>
        </nav>
                  
        <#-- Links -->  
        <@p.vitroLinks propertyGroups namespaces editable "individual-urls-people" />
    </section>

    <section id="individual-info" ${infoClass!} role="region">
        <#include "individual-visualizationFoafPerson.ftl">    
        <#-- Disable for now until controller sends data -->
        <#--
        <section id="co-authors" role="region">
            <header>
                <h3><span class="grey">10 </span>Co-Authors</h3>
            </header>

            <ul role="list">
                <li role="listitem"><a href="#"><img class="co-author" src="" /></a></li>
                <li role="listitem"><a href="#"><img class="co-author" src="" /></a></li>
            </ul>

            <p class="view-all-coauthors"><a class="view-all-style" href="#">View All <img src="${urls.images}/arrowIcon.gif" alt="arrow icon" /></a></p>
        </section>
        -->
        
        <#if individual.showAdminPanel>
            <#include "individual-adminPanel.ftl">
        </#if>
        
        <header>
            <#if relatedSubject??>
                <h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
                <p><a href="${relatedSubject.url}">&larr; return to ${relatedSubject.name}</a></p>
            <#else>                
                <h1 class="fn foaf-person">
                    <#-- Label -->
                    <@p.label individual editable />
                        
                    <#-- Moniker / Preferred Title -->
                    <#-- Use Preferred Title over Moniker if it is populated -->
                    <#assign title = (propertyGroups.getProperty("${core}preferredTitle").firstValue)! />
                    <#if ! title?has_content>
                        <#assign title = individual.moniker>
                    </#if>
                    <#if title?has_content>
                        <span class="preferred-title">${title}</span>
                    </#if>
                </h1>
            </#if>
               
            <#-- Positions -->
            <#assign positions = propertyGroups.getPropertyAndRemoveFromList("${core}personInPosition")!>
            <#if positions?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
                <@p.objectPropertyListing positions editable />
            </#if> 
        </header>
         
        <#-- Overview -->
        <#include "individual-overview.ftl">
        
        <#-- Research Areas -->
        <#assign researchAreas = propertyGroups.getPropertyAndRemoveFromList("${core}hasResearchArea")!> 
        <#if researchAreas?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
            <@p.objectPropertyListing researchAreas editable />
        </#if>   
    </section>
    
</section>
<#assign nameForOtherGroup = "other"> <#-- used by both individual-propertyGroupMenu.ftl and individual-properties.ftl -->

<#-- Property group menu -->
<#include "individual-propertyGroupMenu.ftl">

<#-- Ontology properties -->
<#include "individual-properties.ftl">


${stylesheets.add("/css/individual/individual.css")}
${stylesheets.add("/css/individual/individual-vivo.css")}
                           
<#-- RY Figure out which of these scripts really need to go into the head, and which are needed at all (e.g., tinyMCE??) -->
${headScripts.add("/js/jquery_plugins/getURLParam.js",                  
                  "/js/jquery_plugins/colorAnimations.js",
                  "/js/jquery_plugins/jquery.form.js",
                  "/js/tiny_mce/tiny_mce.js", 
                  "/js/controls.js",
                  "/js/toggle.js",
                  "/js/jquery_plugins/jquery.truncator.js")}
                  
${scripts.add("/js/imageUpload/imageUploadUtils.js")}
${scripts.add("/js/individual/individualUtils.js")}