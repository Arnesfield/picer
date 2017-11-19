<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Upload extends MY_View_Controller {

  public function __construct() {
    parent::__construct();
  }
  
  public function index() {
    if (!$this->input->post()) {
      exit();
    }

    $data = array(
      'name' => $this->input->post('name', TRUE),
      'label' => $this->input->post('label', TRUE),
      'image' => '',
      'status' => 1
    );

    $upload = $this->_upload_image('', 'image');
    
    // do not update if no set
    if ($upload['result']) {
      $data['image'] = $upload['return']['file_name'];
    }
    else {
      $this->_fail(strip_tags($upload['return']));
    }

    $this->load->model('shares_model');

    if ($this->shares_model->insert($data)) {
      $this->_success('Successfully added image.');
    }
    else {
      $this->_fail('Unable to add image.');
    }
  }

  private function _success($data = FALSE) {
    echo json_encode(array(
      'success' => 1,
      'data' => $data
    ));
    exit();
  }

  private function _fail($data = FALSE) {
    echo json_encode(array(
      'success' => 0,
      'data' => $data
    ));
    exit();
  }

  // for image upload
  private function _upload_image($path, $file_name, $p_config = FALSE) {
    
    $config = array(
      'upload_path' => './uploads/' . $path,
      'allowed_types' => 'gif|jpg|png',
      // 'max_size' => 5000,
      // 'max_width' => 1920,
      // 'max_height' => 1080,
      'file_name' => 'IMG_' . date('dmyHis')
    );

    // override default values
    if ($p_config) {
      foreach ($p_config as $key => $value) {
        $config[$key] = $value;
      }
    }

    $this->load->library('upload', $config);

    if (!$this->upload->do_upload($file_name)) {
      return array(
        'result' => FALSE,
        'return' => $this->upload->display_errors()
      );
    }
    else
    {
      return array(
        'result' => TRUE,
        'return' => $this->upload->data()
      );
    }

  }
}

?>