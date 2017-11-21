<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Comment_model extends MY_CRUD_Model {

  public $_tbl = 'comments';

  public function fetch($where, $order_by = array('datetime', 'DESC')) {
    return $this->_read($this->_tbl, array(
      'where' => $where,
      'order_by' => $order_by
    ));
  }

  public function update($data, $where) {
    return $this->_update($this->_tbl, $data, $where);
  }

  public function insert($data) {
    return $this->_create($this->_tbl, $data);
  }
}

?>