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
    $text = $this->input->post('data') ? $this->input->post('data') : '';
    
    $where = "(name LIKE '%$text%' OR label LIKE '%$text%') AND status = 1";
    $shares = $this->shares_model->fetch($where);

    if (!$shares) {
      $this->_fail('No shared photos.');
    }

    foreach ($shares as $key => $share) {
      $shares[$key]['datetime'] = date('d-M-Y H:i', $share['datetime']);
    }

    $this->_success($shares);
  }
}

?>