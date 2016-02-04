<%--
  Created by IntelliJ IDEA.
  User: Yasaman
  Date: 2015-10-30
  Time: 12:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
  <title></title>
  <link href="../css/bootstrap.css" rel="stylesheet">
  <script src="../js/jquery.min.js"></script>
  <script src="../js/bootstrap.min.js"></script>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <div class="page-header">
        <h1>
          Lets start <small>Written test!</small>
        </h1>
      </div>
      <nav class="navbar navbar-inverse">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-2">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">Brand</a>
          </div>

          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-2">
            <ul class="nav navbar-nav">
              <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
              <li><a href="questionAdminPanel">questionAdminPanel</a></li>
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                  <li><a href="#">Action</a></li>
                  <li><a href="#">Another action</a></li>
                  <li><a href="#">Something else here</a></li>
                  <li class="divider"></li>
                  <li><a href="#">Separated link</a></li>
                  <li class="divider"></li>
                  <li><a href="/j_spring_security_logout">Logout</a></li>
                </ul>
              </li>
            </ul>
            <form class="navbar-form navbar-left" role="search">
              <div class="form-group">
                <input type="text" class="form-control" placeholder="Search">
              </div>
              <button type="submit" class="btn btn-default">Submit</button>
            </form>
            <ul class="nav navbar-nav navbar-right">
              <li><a href="#">Link</a></li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
    <div class="col-md-12">
      <div class="panel panel-default">
        <div class="panel-body">
          <c:if test="${!empty questions}">
          <table id="questionTb" class="table table-striped table-hover "data-row-style="rowStyle"  data-show-refresh="true" data-show-toggle="true" data-show-columns="true" data-search="true" data-select-item-name="toolbar1" data-pagination="true" data-sort-name="name" data-sort-order="desc" data-single-select="false" data-click-to-select="true" data-maintain-selected="true">
            <thead>
            <tr class="info">
              <th>
                <input type="checkbox" name="myTextEditBox" value="checked" />
              </th>
              <th>
                #
              </th>
              <th>
                Question
              </th>
              <th>
                Alternative1
              </th>
              <th>
                Alternative2
              </th>
              <th>
                Alternative3
              </th>
              <th>
                Alternative4
              </th>
              <th>
                rightAnswer
              </th>
            </tr>
            </thead>
            <tbody id="questionTable">
            <c:forEach items="${questions}" var="qs">
              <tr>
                <td>
                  <input type="checkbox" name="myTextEditBox" value="checked" />
                </td>
                <td>&nbsp;&nbsp;${qs.questionNo}&nbsp;&nbsp;</td>
                <td>&nbsp;&nbsp;${qs.question}&nbsp;&nbsp;</td>
                <td>&nbsp;&nbsp;${qs.alternative1}&nbsp;&nbsp;</td>
                <td>&nbsp;&nbsp;${qs.alternative2}&nbsp;&nbsp;</td>
                <td>&nbsp;&nbsp;${qs.alternative3}&nbsp;&nbsp;</td>
                <td>&nbsp;&nbsp;${qs.alternative4}&nbsp;&nbsp;</td>
                <td>&nbsp;&nbsp;${qs.rightAnswer}&nbsp;&nbsp;</td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          </c:if>
          <div class="col-md-12">
            <a href="#" class="btn btn-success" onclick="addQuestion()">Add</a>
            <a href="#" class="btn btn-success" onclick="deleteQuestion()">Delete</a>
          </div>
        </div>
      </div>
    </div>
    <div class="modal fade" id="myModal" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h4 class="modal-title">Adding Question</h4>
          </div>
          <div class="modal-body">
            <form class="form-horizontal">
              <fieldset>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Question Number</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="questionNo" type="number">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Right Answer</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="rightAnswer" type="number">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4" >Question</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="question" type="text">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Alternative1</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="alternative1" type="text">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Alternative2</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="alternative2" type="text">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Alternative3</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="alternative3" type="text" >
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Alternative4</label>
                    <div class="col-lg-8">
                      <input class="form-control" id="alternative4" type="text">
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="control-label col-lg-4">Description</label>
                    <div class="col-lg-8">
                      <textarea class="form-control" id="textArea"></textarea>
                    </div>
                  </div>
              </fieldset>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" id="saveQuestion" onclick="saveQuestion()">Save changes</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
  function addQuestion(){
    $("#myModal").modal();

  };
  function saveQuestion(){
    var question = document.getElementById('question').value;
    var questionNo = document.getElementById('questionNo').value;
    var rightAnswer = document.getElementById('rightAnswer').value;
    var alternative1 = document.getElementById('alternative1').value;
    var alternative2 = document.getElementById('alternative2').value;
    var alternative3 = document.getElementById('alternative3').value;
    var alternative4 = document.getElementById('alternative4').value;
    var description = document.getElementById('textArea').value;
    $.ajax({
      url: '/addQuestion',
      data: {'questionEntity.question': question, 'questionEntity.questionNo':questionNo, 'questionEntity.rightAnswer':rightAnswer, 'questionEntity.alternative1':alternative1, 'questionEntity.alternative2':alternative2, 'questionEntity.alternative3':alternative3, 'questionEntity.alternative4':alternative4, 'questionEntity.description':description},
      type: "post",
      cache: false,
      success:function(data) {
        $('#myModal').modal('hide');
        $('#questionTb').bootstrapTable('refresh', {url: '/questionAdminPanel'});
      }
    });

  };
  function deleteQuestion(){
    var arr;
    arr = $('#questionTable').find('[type="checkbox"]:checked').map(function(){
      return parseInt($(this).closest('tr').find('td:nth-child(2)').text());
    }).get();
    $.ajax({
      url: '/deleteQuestion',
      data: {'questionsArr' : arr },
      type: "post",
      traditional: true,
      cache: false,
      success:function(data) {
        $('#questionTb').bootstrapTable('refresh', {url: '/questionAdminPanel'});
      }
    });
  };

</script>

</body>
</html>
