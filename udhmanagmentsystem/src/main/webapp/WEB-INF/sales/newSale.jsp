
<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ include file="../includes/menuAndSideBar.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="com.UDHFashion.udhmanagmentsystem.service.IShopDAO"%>
<%@page import="com.UDHFashion.udhmanagmentsystem.service.ShopDAOImpl"%>
<%@page import="com.UDHFashion.udhmanagmentsystem.model.Shop"%>
<%@page import="com.UDHFashion.udhmanagmentsystem.model.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>



<!-- added unsuccesfull message -->
<script type="text/javascript">
	function unsuccesfull() {
		swal("Sale is Unsuccesfull");
	}
</script>

<c:if test="${error == 1}">
	<script type="text/javascript">
		window.onload = unsuccesfull;
	</script>
</c:if>

<div class="content-page">

	<!-- Start content -->
	<div class="content">

		<div class="container-fluid">


			<div class="row">
				<div class="col-xl-12">
					<div class="breadcrumb-holder">
						<h1 class="main-title float-left">New Sale</h1>
						<ol class="breadcrumb float-right">
							<li class="breadcrumb-item">Home</li>
							<li href="viewAllSales" class="breadcrumb-item active">New
								Sales</li>
						</ol>
						<div class="clearfix"></div>
					</div>
				</div>
			</div>

			<div class="row">

				<div class="col-md-12">
					<div class="card mb-3">
						<div class="col-md-12a">

							<form action="submitItemQty" method="post">

								<div class="form-row">
									<div class="form-group col-md-4" style="margin: 20px">
										<label for="exampleInputEmail1">Item No</label> <input
											list="hosting-plan" type="text" name="itemcode"
											class="form-control" id="itemcode"
											aria-describedby="numberlHelp" placeholder="" autofocus
											required>

										<datalist id="hosting-plan">
											<c:forEach var="result" items="${itemList}">

												<option value="${result.itemCode}" />
											</c:forEach>
										</datalist>

									</div>

									<div class="form-group col-md-4" style="margin: 20px">
										<label for="exampleInputEmail1">Quantity</label> <input
											type="number" name="quantity" class="form-control"
											id="quantity" aria-describedby="numberlHelp" Value="1"
											required>

									</div>
									<div style="margin: 50px">
										<button type="submit" class="btn btn-primary">Submit</button>

									</div>


								</div>



							</form>



						</div>

						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-responsive-xl table-bordered">
									<thead>
										<tr>

											<th>Item No</th>
											<th>Unit Price</th>
											<th>Quantity</th>
											<th>Reduce Discount</th>
											<th>Amount</th>
									</thead>
									<tbody>

										<c:forEach var="result" items="${itemList1}">
											<tr>
												<td>${result.itemNo}</td>
												<td>${result.price}</td>
												<td>${result.qty}</td>
												<td>${result.reduseDiscount}</td>
												<td>${result.amount}</td>

												<c:set var="total" value="${0}" />

												<c:forEach var="result" items="${itemList1}">
													<c:set var="total" value="${total + (result.price * result.qty  )}" />
												</c:forEach>
												<c:set var="totalDis" value="${0}" />
												<c:forEach var="resultDis" items="${itemList1}">
													<c:set var="totalDis"
														value="${totalDis + resultDis.reduseDiscount}" />
												</c:forEach>

												<c:set var="totalAmt" value="${0}" />
												<c:forEach var="resultAmt" items="${itemList1}">
													<c:set var="totalAmt"
														value="${totalAmt + resultAmt.amount}" />
												</c:forEach>

											</tr>
										</c:forEach>

									</tbody>
								</table>

							</div>
							<div>
								<form method="POST" action="finalizeBill"
									modelAttribute="permanentBill">

									<div class="form-row">

										<div class="form-group col-md-5">
											<label for="exampleInputEmail1">No of Items</label> <input
												type="number" name="noOfItem" class="form-control"
												id="noOfItem" aria-describedby="numberlHelp" placeholder="2"
												value="<c:out value="${total_items}" />" required>
										</div>
										<div class="col-md-1"></div>

									</div>
									<div class="form-row">
										<div class="form-group col-md-5">
											<label for="exampleInputEmail1">Gross Amount</label> <input
												type="text" name="grossAmount" class="form-control"
												id="grossAmount" aria-describedby="numberlHelp"
												value="<c:out value="${total + result.price}"/>" required>
										</div>
										<div class="col-md-1"></div>
										<div class="form-group col-md-5">
											<label for="exampleInputPassword1">Total Discount</label> <input
												type="text" name="totalDiscount" class="form-control"
												id="totalDiscount"
												value="<c:out value="${totalDis + resultDis.reduseDiscount}"/>"
												required>
										</div>
									</div>

									<div class="form-row">
										<div class="form-group col-md-5">
											<label for="exampleInputEmail1">Net Amount</label> <input
												type="number" name="netAmount" class="form-control"
												id="netAmount" aria-describedby="numberlHelp"
												value="<c:out value="${totalAmt + resultDis.amount}"/>"
												required>

										</div>
										<div class="col-md-1"></div>
										<div class="form-group col-md-5">
											<label for="exampleInputEmail1">Return Note Amount</label> <input
												type="number" name="returnAmount" class="form-control"
												id="returnAmount" aria-describedby="numberlHelp"
												placeholder="2" value="0" onkeyup='balance1();' />

										</div>


									</div>

									<div class="form-row">
										<br> <br>
										<h6 id="remain"></h6>
										<br> <br>
									</div>

									<div class="form-row">
										<div class="form-group col-md-5">
											<label for="exampleInputEmail1">Cash</label> <input
												type="number" name="cash" class="form-control" id="cash"
												onkeyup='balance1();' aria-describedby="numberlHelp"
												required />
										</div>
										<div class="col-md-1"></div>

										<div class="form-group col-md-5">
											<label for="exampleInputEmail1">Balance</label> <input
												type="number" name="balance" class="form-control"
												onkeyup='balance1();' id="balance"
												aria-describedby="numberlHelp" required />

										</div>
									</div>

									<%
										User user = (User) session.getAttribute("user");
									%>



									<input type="hidden" id="cashireId" path="cashireId"
										name="cashireId" value="${user.getId()}"> <br> <br>
									<div>
										<br>
										<div class="row">
											<div class="offset-md-5 col-md-1 ">
												<button type="submit" style="width: 100px"
													class="btn btn-primary" name="finallize">
													<span class="fa fa-print" aria-hidden="true"></span>
													Finalize
												</button>
											</div>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- END container-fluid -->

		</div>
		<!-- END content -->

	</div>
</div>



<script>
	var balance1 = function() {
		if (document.getElementById('returnAmount').value !== '') {
			var netAmount = document.getElementById('netAmount').value;
			var returnAmount = document.getElementById('returnAmount').value
			var cash = parseInt(document.getElementById("cash").value);

			var more = netAmount - returnAmount;

			if (more < 0) {
				more = 0;

				if (returnAmount != 0) {
					document.getElementById('remain').innerHTML = ' \t Customer Need to pay Rs.'
							+ more + ' more';
				}
				var balance = cash - more;

				document.getElementById("balance").value = 0;

				document.getElementById("cash").value = 0;
			} else {
				if (returnAmount != 0) {
					document.getElementById('remain').innerHTML = ' \t Customer Need to pay Rs.'
							+ more + ' more';
				}
				var balance = cash - more;

				document.getElementById("balance").value = balance;

			}

		} else if (document.getElementById('netAmount').value !== 0) {

			var netAmount = document.getElementById('netAmount').value;
			var cash = parseInt(document.getElementById("cash").value);
			var balance = cash - netAmount;

			document.getElementById("balance").value = balance;
		}
	}
</script>

<%@ include file="../includes/footer.jsp"%>
