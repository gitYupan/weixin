<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>成品出库查询</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/static/img/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/plugins/jquery.mobile-1.4.5/css/themes/default/jquery.mobile-1.4.5.min.css">
</head>
<body>

<div data-role="page" id="index">

    <div data-role="header" data-position="fixed" data-tap-toggle="false">
        <h1>成品出库查询</h1>
        <a href="${pageContext.request.contextPath}/" target="_top" class="ui-btn ui-btn-icon-notext ui-corner-all ui-icon-home ui-nodisc-icon ui-alt-icon ui-btn-left">菜单</a>
    </div><!-- /header -->

    <div role="main" class="ui-content">
        <div data-role="collapsibleset" data-theme="a" data-content-theme="a" data-collapsed-icon="carat-l" data-expanded-icon="carat-d" data-iconpos="right">
            <div data-role="collapsible" data-collapsed="false">
                <h3>查询条件</h3>
                <form method="post">
                    <fieldset>
                        <div class="ui-grid-a">
                            <div class="ui-block-a">
                                <input type="date" name="date" id="beginDate" value="">
                            </div>
                            <div class="ui-block-b">
                                <input type="date" name="date" id="endDate" value="">
                            </div>
                        </div>
                        <div class="ui-grid-a">
                            <div class="ui-block-a">
                                <input type="text" name="customerName" id="customerName" value="" placeholder="客户简称">
                            </div>
                            <div class="ui-block-b">
                                <input type="text" name="custOrderNO" id="custOrderNO" value="" placeholder="客来单号">
                            </div>
                        </div>
                        <div class="ui-grid-a">
                            <div class="ui-block-a">
                                <button type="button" class="ui-btn ui-btn-a ui-icon-back ui-btn-icon-left ui-shadow ui-corner-all" onclick="cancelData();">取消</button>
                            </div>
                            <div class="ui-block-b">
                                <button type="button" class="ui-btn ui-btn-b ui-icon-check ui-btn-icon-left ui-shadow ui-corner-all" onclick="buttonData();">查询</button>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
        <ul data-role="listview" data-inset="true" id="asmOutHeadResult">

        </ul>
    </div><!-- /content -->

    <div data-role="footer" data-position="fixed">
        <h4><span id="total">总匹数：0,总重量：0</span></h4>
    </div>

</div><!-- /page -->

<script src="${pageContext.request.contextPath}/static/plugins/jquery.mobile-1.4.5/js/jquery.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/jquery.mobile-1.4.5/js/jquery.mobile-1.4.5.min.js"></script>
<script src="${pageContext.request.contextPath}/static/plugins/js/jquery.ext.js"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
    var defaultPage = 1;
    var defaultRows = 10;
    var order = "f.AccDT desc";
    $(function () {
        var now = new Date();
        now.setDate(now.getDate() -1);
        var time = now.Format("yyyy-MM-dd");
        $("#beginDate").val(time);
        $("#endDate").val(time);
        buttonData();
    });
    function cancelData() {
        $("#beginDate").val("");
        $("#endDate").val("");
        $("#customerName").val("");
        $("#custOrderNO").val("");
        buttonData();
    }
    function buttonData() {
        defaultPage = 1;
        defaultRows = 10;
        findAsmInOutData(defaultPage, defaultRows, false);
    }
    function clickMore() {
        defaultPage += 1;
        defaultRows += 10;
        findAsmInOutData(defaultPage, defaultRows, true);
    }
    function findAsmInOutData(page, rows, isAppend) {
        var params = {
            "page": page,
            "rows": rows,
            "order": order
        };
        if ($("#beginDate").val() != '') {
            params.beginDate = $("#beginDate").val();
        }
        if ($("#endDate").val() != '') {
            params.endDate = $("#endDate").val();
        }
        if ($("#customerName").val() != '') {
            params.customerName = $("#customerName").val();
        }
        if ($("#custOrderNO").val() != '') {
            params.custOrderNO = $("#custOrderNO").val();
        }
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/fab/findFabOutHead",
            dataType: "JSON",
            data: params,
            success: function (data) {
                //console.log(data);
                appendHtml(data, isAppend);
            }
        });
    }
    function appendHtml(dataList, isAppend) {
        var appendHtml = "";
        $("#clickMore").remove();
        if (dataList && dataList.length > 0) {
            $.each(dataList, function (index, value) {
                if (dataList.length-1 === index) {
                    if (value) {
                        $("#total").text("总匹数：" + value.Pieces + ",总重量：" + value.Weights);
                    } else {
                        $("#total").text("总匹数：0,总重量：0");
                    }
                } else {
                    var colorName = value.ColorCode + "->" + value.SName;
                    appendHtml += "<li data-role='list-divider'>" + value.AccNo + "<span class='ui-li-count'>匹数：" + value.Pieces + "</span></li>";
                    appendHtml += "<li><h2>客户简称：" + value.ParSingleName + "</h2>";
                    appendHtml += "<p><strong>计划缸号：" + value.FabOutNO + "</strong></p>";
                    appendHtml += "<p><strong>客来单号：" + value.CustOrderNO + "</strong></p>";
                    appendHtml += "<p><strong>布类名称：" + value.ProdNameC + "</strong></p>";
                    appendHtml += "<p><strong>色号：" + colorName + "</strong></p>";
                    appendHtml += "<p><strong>门幅：" + value.widesize + "</strong></p>";
                    appendHtml += "<p><strong>克重：" + value.fndHeight + "</strong></p>";
                    appendHtml += "<p class='ui-li-count'><strong>出库时间：" + value.AccDT + "</strong></p>";
                    appendHtml += "<p class='ui-li-aside'><strong>出库重量：" + value.Quan + "</strong></p>";
                    appendHtml += "</li>";
                }
            });
            if (isAppend) {
                $("#asmOutHeadResult").append(appendHtml);
            } else {
                $("#asmOutHeadResult").html(appendHtml);
            }
            $("#asmOutHeadResult").append("<li id='clickMore'><a href='javascript:clickMore();'><h2><strong>点击加载更多数据</strong></h2></a></li>");
        } else {
            if (isAppend) {
                $("#asmOutHeadResult").append("<li data-role='list-divider'>数据已全部加载完成！</li>");
            } else {
                $("#asmOutHeadResult").html("<li data-role='list-divider'>当前条件没有更多数据！</li>");
            }
        }
        $("#asmOutHeadResult").listview("refresh");
    }
</script>
</body>
</html>
