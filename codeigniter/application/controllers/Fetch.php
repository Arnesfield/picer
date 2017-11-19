<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Fetch extends MY_Custom_Controller {

  public function __construct() {
    parent::__construct();
  }
  
  public function index() {
    if (!$this->input->post('fetch')) {
      exit();
    }

    $this->load->model('shares_model');

    $shares = $this->shares_model->fetch(array());

    if (!$shares) {
      $this->_fail('No shared photos.');
    }

    $this->_success($shares);
  }
}

?>