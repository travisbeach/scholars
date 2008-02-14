<jsp:include page="header.jsp" />
		
		<div id="contentWrap">
			<div id="content">
				<h2 class="initial">Explore our Graduate Fields</h2>
				
				<jsp:include page="part/gradfieldgrouplist.jsp"/>
				
				<p>On campus, a biorevolution has transformed research. Biology is no longer just being done by biologists. Scientists and scholars from traditionally separate disciplines pursue biological questions and work with biological systems and biologists.</p>
				<div id="apply">
					<p>Begin the process of studying in one of the world's most exciting and diverse academic environments.</p>
					<a href="#" id="applyButton" title="Apply"><img src="images/layout/button_apply.gif" alt="Apply"/></a>
				</div>
			</div><!-- content -->
		
			<div id="sidebar">
				<div id="news">
					<h2>Life Sciences News</h2>
				    <jsp:include page="part/newsforportal.jsp" />
				</div>
				<div id="search">
					<h2>Find Research</h2>
				</div>
				<div id="seminars">
					<h2>Life Sciences Seminars</h2>
					<jsp:include page="part/seminarsforportal.jsp" />
				</div>
			</div> <!-- sidebar -->
		</div> <!-- contentWrap -->

<jsp:include page="footer.jsp" />