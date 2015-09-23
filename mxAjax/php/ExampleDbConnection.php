<?php
	class ExampleDbConnection
	{
		var $dbh;
		function ExampleDbConnection()
		{
			$this->dbh = new PDO('mysql:host=209.132.230.101;dbname=indiankey', "indiankey", "manager");
		}
		
		function getPhoneModel($make = "", $model = "")
		{
			if ($make != "") {
				return $this->dbh->query("SELECT * FROM phoneModel WHERE make = '" . $make . "'");
			} else if ($model != "") {
				return $this->dbh->query("SELECT * FROM phoneModel WHERE model = '" . $model . "'");
			}
		}
		
		function getPhoneMakeDescription($make = "")
		{
			return $this->dbh->query("SELECT * FROM phoneMake WHERE make = '" . $make . "'");
		}
		
		function getContent($id)
		{
			return $this->dbh->query("SELECT * FROM content WHERE id =" . $id);
		}

		function getRandomQuote()
		{
			$id=1;
			return $this->dbh->query("SELECT * FROM quote WHERE id >" . $id);
		}

		function getRandomFact()
		{
			$id=1;
			return $this->dbh->query("SELECT * FROM facts WHERE id > " . $id);
		}

		function getState($searchCharacter)
		{
			return $this->dbh->query("SELECT Code , Name  from state WHERE search like '" . strtolower($searchCharacter) . "%'");
		}
		
		function getAllQuote()
		{
			return $this->dbh->query("SELECT * FROM quote");
		}
		
	}
?>