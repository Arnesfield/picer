<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Shares_model extends MY_CRUD_Model {

  public $_tbl = 'shares';

  public function fetch($where) {
    return $this->_read($this->_tbl, array('where' => $where));
  }

  public function update($data, $where) {
    return $this->_update($this->_tbl, $data, $where);
  }

  public function insert($data) {
    return $this->_create($this->_tbl, $data);
  }
}

?>