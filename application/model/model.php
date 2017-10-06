<?php

class Model
{
    public $db;

    /**
     * @param DBConnection|object $db A PDO database connection
     */
    function __construct(DBConnection $db)
    {
        try {
            $this->db = $db->connection;
        } catch (PDOException $e) {
            exit('Database connection could not be established.');
        }
    }
}