<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Comment extends MY_Custom_Controller {

  public function __construct() {
    parent::__construct();
  }
  
  public function index() {
    if (!$this->input->post()) {
      exit();
    }

    $data = array(
      'share_id' => $this->input->post('sid', TRUE),
      'name' => $this->input->post('name', TRUE),
      'label' => $this->input->post('label', TRUE),
      'datetime' => time(),
      'status' => 1
    );

    $this->load->model('comment_model');

    if ($this->comment_model->insert($data)) {
      $this->_success('Successfully added comment.');
    }
    else {
      $this->_fail('Unable to add comment.');
    }
  }
  
}

?>