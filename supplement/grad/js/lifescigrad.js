// Graduate field pages
$(document).ready(function() {
if ($("body").attr("id") == "fields") {
        
    // Toggle Links
    $("body#fields span.toggleLink").click(function () {
        $("div.readMore").slideToggle("medium");
        $(this).toggleClass("toggled");
        return false;     
    });

    // Highlighting faculty members by research rrea
    var parameter = $.getURLParam("uri");
    var jsonLink = "data/researchAreas.jsp" + "?uri=" + parameter;

    $.getJSON(jsonLink, function(json) {
        $("ul.researchAreaList li a").click(function(){
            if ($(this).hasClass("selected")) {
                $("div#researchAreas li a").removeClass("selected");
                $("div#fieldFaculty li").blur().removeClass("selected");
            }
            else {
                $("div#researchAreas li a").removeClass("selected");
                $("div#fieldFaculty li").removeClass("selected");
                $(this).blur().addClass("selected");
                var selectedID = $(this).parent().attr("id");
                $.each(json.research, function(i, area) {
                    if (area.ID == selectedID) {
                        $.each(json.research[i].Faculty, function(n, faculty) {
                            var targetFaculty = "li#" + json.research[i].Faculty[n];
                            $(targetFaculty).addClass("selected");
                        });
                    }
                });
            } 
        return false;
        });
    }); 
}
}); 


// Department pages
$(document).ready(function() {
if ($("body").attr("id") == "departments") {
    
     $("body#departments span.toggleLink").click(function () {
        $("ul#moreProjects").slideToggle("medium");
        $(this).toggleClass("toggled");
        return false;
     });
}
}); 


// Faculty index Page
$(document).ready(function() {
if ($("body").attr("id") == "faculty") {
      
     // Pagination functions
     var origCount = $("tfoot td").text();
     $("#indexNav").append('<a id="showAll" href="#">show all<\/a>');
     $("#indexNav a#showAll").click(function(){
         $("tbody").show();
         $("tfoot td").text("Total: " + origCount);
         $(this).blur();
         return false;
     });
     $("#indexNav a").not("#showAll").click(function(){
         var tbodyID = "#" + $(this).text();
         var count = $("tbody"+ tbodyID + " tr").length;
         $("tbody").not(tbodyID).hide();
         $("tbody").filter(tbodyID).show().each(function(){
             $(this).children("tr").children("td:first").css("padding-top", "12px");
         });
         $("tfoot td").empty().text("Total: " + count);
         $(this).blur();
         return false;
     });
    
    $("td a.person").cluetip({
        titleAttribute: 'name', 
        width: '200px', 
        showTitle: false, 
        waitImage: false, 
        arrows: true,
        dropShadowSteps: 8,
        leftOffset: 30,
        topOffset: 30
    });
    
    $("div#fieldFaculty").cluetip({
        titleAttribute: 'name', 
        width: '200px', 
        showTitle: false, 
        waitImage: false, 
        arrows: true,
        dropShadowSteps: 8,
        leftOffset: 30,
        topOffset: 30
    });
} 
});



// Graduate group pages
$(document).ready(function() {
if ($("body").attr("id") == "groups") {

        var parameter = $.getURLParam("uri");
        var jsonLink = "data/fieldsHoverData.jsp" + "?uri=" + parameter;
        var hoverDivs = '<div id="hoverBox"><h4>Overview</h4><div id="fieldDescription"></div><h4>Departments</h4><div id="fieldDepartments"></div></div>';
        $("h2.groupLabel").after(hoverDivs);
    
        function fieldHoverSwitch(targetFieldID, json) {
            $("div#hoverBox").show();
            $.each(json.Fields, function(i, field) {
                if (field.ID == targetFieldID) {
                    $("div#hoverBox h4").hide();
                    $("div#fieldDescription").hide().empty().append(field.Description);
                    $("div#fieldDepartments").hide().empty().append("<ul></ul>");
                    $.each(field.Departments, function(i, dept) {
                        var newListItem = "<li>" + field.Departments[i].Label + "</li>";
                        $("div#fieldDepartments ul").append(newListItem);
                    });
                    $("div#fieldDescription, div#fieldDepartments, div#hoverBox h4").fadeIn("fast");
                }
            });
        }
        
        function changeSelected(targetFieldID) {
            $("ul.fields li a").removeClass("selected");
            $("ul.fields li." + targetFieldID + " a").addClass("selected");
        }
    
        $.getJSON(jsonLink, function(fieldsJSON) {
            var json = fieldsJSON;
            var fieldsCount = json.Fields.length - 1;
            var randomField = Math.floor(Math.random()*fieldsCount);
            var initialField = json.Fields[randomField].ID;
            
            changeSelected(initialField);
            fieldHoverSwitch(initialField, json);
                        
            $("ul.fields li a").mouseover(function() {
                var thisField = $(this).parent().attr("class");
                changeSelected(thisField);
                fieldHoverSwitch(thisField, json);
            });
        });
} 
}); 

// Facilities page
$(document).ready(function() {
if ($("body").attr("id") == "facilities") {
    
    $("h3 + ul").hide();
    initialGroup = document.location.hash.substring(5);
    // alert(initialGroup);
    if (initialGroup != "") {
        $("li#" + initialGroup + " ul").show();
        $("li#" + initialGroup + " h3:first").addClass("expanded");
    }
    
    $("h3.facilityGroup").css("cursor", "pointer").click( function(){
        $(this).parent().children("ul").slideToggle("medium");
        if ($(this).hasClass("expanded")) { 
            $(this).removeClass("expanded");
        }
        else {
            $(this).addClass("expanded");
        }
    });
    $("a.facilityPage").click( function(){
        groupID = $(this).parents("ul.facilityList").parent().attr("id");
        document.location.hash = "Tab-" + groupID;
        // alert(groupID);
        // return false;
    });
}
});
