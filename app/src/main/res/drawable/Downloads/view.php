<?php
include 'kon.php';
$q ='select * from mha';
$result = mysqli_query($con,$q);
?>

<table border=1>
    <tr>
		<td>no </td>
		<td>npm</td>
		<td>nama</td>
		<td>alamat </td>
		<td> edit / delete </td>
	</tr>
<?php
while ($row=mysqli_fetch_array($result, MYSQLI_ASSOC))
{
    ?>
    <tr>
		<td> <?php echo $row['id'];?> </td>
		<td> <?php echo $row['npm'];?> </td>
		<td> <?php echo $row['nama'];?> </td>
		<td> <?php echo $row['alamat'];?> </td>
		<td> <a href='edit.php?id=<?php echo $row['id'];?>&npm=<?php echo $row['npm'];?>&nama=<?php echo $row['nama'];?>&alamat=<?php echo $row['alamat'];?>'> edit </a> / <a href='delete.php'> delete <a>  </td>
	</tr>
    <?php
}
?>

