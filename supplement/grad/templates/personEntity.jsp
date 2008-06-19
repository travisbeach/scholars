<%@ page import="com.thoughtworks.xstream.XStream" %>
<%@ page import="com.thoughtworks.xstream.io.xml.DomDriver" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.beans.Individual" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://djpowell.net/tmp/sparql-tag/0.1/" prefix="sparql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://mannlib.cornell.edu/vitro/ListSparqlTag/0.1/" prefix="listsparql" %>
<%@ taglib uri="http://jakarta.apache.org/taglibs/string-1.1" prefix="str" %>
<%@ taglib uri="http://jakarta.apache.org/taglibs/random-1.0" prefix="rand" %>

<%@ page errorPage="/error.jsp"%>
<%  /***********************************************
     Display a single Department Entity for the grad portal.

     request.attributes:
     an Entity object with the name "entity"
     **********************************************/
    Individual entity = (Individual)request.getAttribute("entity");
    if (entity == null)
        throw new JspException("personEntity.jsp expects that request attribute 'entity' be set to the Entity object to display.");
%>

<fmt:setLocale value="en_US"/>    

<c:set var="researchFocus" value="${entity.dataPropertyMap['http://vivo.library.cornell.edu/ns/0.1#researchFocus'].dataPropertyStatements[0].data}"/>
<c:set var="selectedPubs" value="${entity.dataPropertyMap['http://vivo.library.cornell.edu/ns/0.1#publications'].dataPropertyStatements[0].data}"/>
<c:set var="researchAreas" value="${entity.objectPropertyMap['http://vivo.library.cornell.edu/ns/0.1#PersonHasResearchArea'].objectPropertyStatements}"/>
<c:set var="primaryInvestigator" value="${entity.objectPropertyMap['http://vivo.library.cornell.edu/ns/0.1#PersonPrimaryInvestigatorOfFinancialAward'].objectPropertyStatements}"/>
<c:set var="authorOf" value="${entity.objectPropertyMap['http://vivo.library.cornell.edu/ns/0.1#authorOf'].objectPropertyStatements}"/>
<c:set var="teaches" value="${entity.objectPropertyMap['http://vivo.library.cornell.edu/ns/0.1#PersonTeacherOfSemesterCourse'].objectPropertyStatements}"/>

<%-- <c:forEach var="id" items="${entity.externalIds}">
    <c:if test="${id.uri == 'http://vivo.library.cornell.edu/ns/0.1#CornellemailnetId'}">
        <c:set var="email" value="${id.value.string}"/>
    </c:if>
</c:forEach> --%>
<%-- <c:set var="email" value="${entity.externalIds['[0].data.dataPropertyStatements[0].data'].dataPropertyStatements[].data}"/> --%>
<c:set var="gradFields" value="${entity.objectPropertyMap['http://vivo.library.cornell.edu/ns/0.1#AcademicEmployeeOtherParticipantAsFieldMemberInAcademicInitiative'].objectPropertyStatements}"/>
<c:set var="departments" value="${entity.objectPropertyMap['http://vivo.library.cornell.edu/ns/0.1#holdFacultyAppointmentIn'].objectPropertyStatements}"/>
<c:set var="education" value="${entity.dataPropertyMap['http://vivo.library.cornell.edu/ns/0.1#educationalBackground'].dataPropertyStatements[0].data}"/>
<c:set var="awards" value="${entity.dataPropertyMap['http://vivo.library.cornell.edu/ns/0.1#awardsAndDistinctions'].dataPropertyStatements[0].data}"/>

<%-- <c:set var='coInvestigator' value='http://vivo.library.cornell.edu/ns/0.1#PersonCoInvestigatorOfFinancialAward'/> --%>
<%-- <c:set var='featuredIn' value='http://vivo.library.cornell.edu/ns/0.1#featuredPersonIn2'/> --%>
<%-- <c:set var='headOf' value='http://vivo.library.cornell.edu/ns/0.1#PersonLeadParticipantForOrganizedEndeavor'/> --%>

<c:set var='imageDir' value='../images/' scope="page"/>

<sparql:sparql>
<listsparql:select model="${applicationScope.jenaOntModel}" var="rs" person="<${param.uri}>">
      PREFIX vivo: <http://vivo.library.cornell.edu/ns/0.1#>
      SELECT DISTINCT ?netid
      WHERE
      {
      ?person vivo:CornellemailnetId ?netid . 
      OPTIONAL { ?person vivo:nonCornellemail ?otherid }
      }
      LIMIT 10
</listsparql:select>
</sparql:sparql>

<c:forEach items="${rs}" var="faculty" begin="0" end="0">
    <c:set var="cornellEmail" value="${faculty.netid.string}"/>
    <c:set var="otherEmail" value="${faculty.otherid.string}"/>
</c:forEach>

<div id="overview">
    <c:if test="${!empty entity.imageThumb}">
        <c:url var="imageSrc" value='${imageDir}/${entity.imageThumb}'/>
        <img src="<c:out value="${imageSrc}"/>" title="click to view larger image in new window" alt="" width="150"/>
        <c:if test="${!empty entity.citation}">
            <%-- <div class="citation">${entity.citation}</div>--%>
        </c:if>
    </c:if>
    <c:set var="firstName" value="${fn:substringAfter(entity.name,',')}"/>
    <c:set var="lastName" value="${fn:substringBefore(entity.name,',')}"/>
    <h2>${firstName}&nbsp;${lastName}</h2>
    <em>${entity.moniker}</em>
    <p class="clear">
        <c:if test="${!empty researchAreas}">
            <strong>Primary Interests: </strong> 
            <c:forEach var="areas" items="${researchAreas}" varStatus="count">
                <c:if test="${count.last == false}">${areas.object.name}; </c:if>
                <c:if test="${count.last == true}">${areas.object.name}</c:if>
            </c:forEach>
        </c:if>
    <c:if test="${!empty researchFocus}">
        <div class="description"><h4>Research Focus:</h4>${researchFocus}</div>
    </c:if>
</div>

<c:if test="${!empty primaryInvestigator}">
<div id="faculty-research">
    <h3>Research</h3>
    <ul>
        <c:forEach var="research" items="${primaryInvestigator}">
        <c:url var="grantHref" value="/entity">
            <c:param name="uri" value="${research.object.URI}"/>
        </c:url>    
            <li><a title="more about this in VIVO" href="${grantHref}">${research.object.name}</a></li>
        </c:forEach>
    </ul>
</div>
</c:if>

<c:if test="${!empty authorOf}">
<div id="faculty-publications">
    <h3>Publications</h3>
    <ul>
        <c:forEach var="publications" items="${authorOf}">
        <c:url var="pubHref" value="/entity">
            <c:param name="uri" value="${publications.object.URI}"/>
        </c:url>    
            <li><a title="more about this in VIVO" href="${pubHref}">${publications.object.name}</a></li>
        </c:forEach>
        <div>${selectedPubs}</div>
    </ul>
</div>
</c:if>

<c:if test="${!empty teaches}">
<div id="faculty-teaching">
    <h3>Teaching</h3>
    <ul>
        <c:forEach var="courses" items="${teaches}">
        <c:url var="courseHref" value="/entity">
            <c:param name="uri" value="${courses.object.URI}"/>
        </c:url>    
            <li><a title="more about this in VIVO" href="${courseHref}">${courses.object.name}</a>
                <p>${courses.object.description}</p>
            </li>
        </c:forEach>
    </ul>
</div>
</c:if>

</div> <!-- content -->

<div id="sidebar">
    
    <div id="contactInfo">
    <h3>Contact Information</h3>        
        <table>
            <tr>
                <th>Email:</th>
                <td>
                    <c:choose>
                        <c:when test="${!empty cornellEmail}"><a title="" href="mailto:${cornellEmail}">${cornellEmail}</a></c:when>
                        <c:otherwise><a title="" href="mailto:${otherEmail}">${otherEmail}</a></c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
        <c:if test="${!empty entity.linksList}">
            <ul id="profileLinks">
                <c:forEach items="${entity.linksList}" var='link'>
                    <c:url var="linkUrl" value="${link.url}" />
                    <li><a title="visit this site" href="<c:out value="${linkUrl}"/>">${link.anchor}</a></li>
                </c:forEach>
            </ul>
        </c:if>
    </div><!-- contactinfo -->

<c:if test="${!empty gradFields}">
    <h3>Graduate Fields</h3>
    <ul>
        <c:forEach var="fields" items="${gradFields}">
        <c:url var="fieldHref" value="fields.jsp">
            <c:param name="uri" value="${fields.object.URI}"/>
            <c:param name="fieldLabel" value="${fields.object.name}"/>
        </c:url>    
            <li>
                <a title="more about this field" href="${fieldHref}">${fields.object.name}</a>
            </li>
        </c:forEach>
    </ul>
</c:if>

<c:if test="${!empty departments}">
    <h3>Departments</h3>        
    <ul>
        <c:forEach var="dept" items="${departments}">
        <c:url var="deptHref" value="departments.jsp">
            <c:param name="uri" value="${dept.object.URI}"/>
            <c:param name="deptLabel" value="${dept.object.name}"/>
        </c:url>    
            <li>
                <a title="more about this department" href="${deptHref}">${dept.object.name}</a>
            </li>
        </c:forEach>
    </ul>
</c:if>

<c:if test="${!empty education}">
    <h3>Education</h3>
    <div id="education">${education}</div>
</c:if>

<c:if test="${!empty awards}">
    <h3>Awards</h3>
    <div id="awards">${awards}</div>
</c:if>

</div> <!-- sidebar -->

<%!
        private void dump(String name, Object fff){
        XStream xstream = new XStream(new DomDriver());
        System.out.println( "*******************************************************************" );
        System.out.println( name );
        System.out.println(xstream.toXML( fff ));
    }

%>