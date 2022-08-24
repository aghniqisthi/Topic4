<html>

<head>
	<title>halo</title>
	<style type="text/css">
		div.part1 {
			float: right;
			border: 1px solid gray;
			width: 80%;
			padding: 10px;
		}

		.gambar {
			width: 200px;
			float: left;
			margin-right: 10px;
			margin-bottom: 10px;
		}
	</style>
</head>

<body bgcolor="aqua">

<?php
//tangkap parameter dari view, memakai method GET
$idku=$_GET['id'];
$npmku=$_GET['npm'];
$namaku=$_GET['nama'];
$alamatku=$_GET['alamat'];
?>
	<h1>halaman edit data</h1>
	<p>
		<form action="proses_edit.php" method="post">	
			<table>
                <tr>
					<td>npm </td>
					<td>:</td>
					<td><input type="text" id="npm" name="npmku" value="<?php echo $npmku;?>">
                    <input type="hidden" id="id" name="idku" value="<?php echo $idku;?>"></td>
				</tr>
				<tr>
					<td>nama </td>
					<td>:</td>
					<td><input type="text" id="nama" name="namaku" value="<?= $namaku;?>"></td>
				</tr>
				<tr>
					<td>alamat </td>
					<td>:</td>
					<td><input type="text" name="alamatku" value="<?= $alamatku;?>"></td>
				</tr>
				<tr>
					<td colspan="3"><input type="submit"></td>
				</tr>
			</table>
		</form>
</body>

</html>