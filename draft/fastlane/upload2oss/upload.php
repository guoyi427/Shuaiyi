<?php
error_reporting(E_ALL);
//调用方式   php upload.php XXX_3.2.ipa
array_shift($argv);
$file = $argv[0];
$envs = [
    1 => [
        "name" => "测试环境",
        "mysql_server" => "121.40.179.94:34381",
        "mysql_username" => "kdy_main",
        "mysql_password" => "fh&*hfH924!9JfgJhnf",
        "mysql_database" => "cias_cms",
    ],
    2=>[
        "name" => "正式环境",
        "mysql_server" => "120.27.238.37:44071",
        "mysql_username" => "kdy_main",
        "mysql_password" => "fh&*hfH924!9JfgJhnf",
        "mysql_database" => "cias_cms",
    ]
];
start:
do {
    foreach ($envs as $k=>$v){
        fwrite(STDOUT, "{$k}）{$v['name']}\n");
    };
    fwrite(STDOUT, "请输入环境序号：\n");
    $env = trim(fgets(STDIN));
} while (!array_key_exists($env, [1, 2]));
$env=$envs[$env];
do {
    fwrite(STDOUT, "输入租户ID:\n");
    $tenantId = trim(fgets(STDIN));
} while ($tenantId == "");
do {
    fwrite(STDOUT, "输入应用名称:\n");
    $name = trim(fgets(STDIN));
} while ($name == "");
do {
    fwrite(STDOUT, "输入版本号:\n");
    $version = trim(fgets(STDIN));
} while ($version == "");
fwrite(STDOUT, str_pad("", 50, "=") . "\n" . str_pad("=发布环境：{$env['name']}", 49, " ") . "=\n" . str_pad("=租户ID：{$tenantId}", 49, " ") . "=\n". str_pad("=应用名称：{$name}", 49, " ") . "=\n" . str_pad("=版本号：{$version}", 49, " ") . "=\n" . str_pad("", 50, "=") . "\n");
do {
    fwrite(STDOUT, "以上信息是否正确，yes或者no:\n");
    $ensure = trim(fgets(STDIN));
} while (!in_array($ensure, ['yes', 'no']));
if ($ensure == "no") {
    goto start;
}
$ossPath = saveFile($file, basename($file));
if ($ossPath) {
    //判断是否打包成功并把连接写入数据库
    $mysql_server = $env['mysql_server'];
    $mysql_username = $env['mysql_username'];
    $mysql_password = $env['mysql_password'];
    $mysql_database = $env['mysql_database'];
//建立数据库链接
    $conn = new mysqli($mysql_server, $mysql_username, $mysql_password,$mysql_database);
//选择某个数据库
    $conn->query("SET NAMES utf8");
    $sql = "insert into  packet (`appName`,`tenantId`,`version`,`packetType`,`apkUrl`,`createTime`) values('{$name}','{$tenantId}','{$version}',1,'{$ossPath}','".date("Y-m-d H:i:s")."')";
    fwrite(STDOUT, "文件上传成功：{$ossPath}\n");
    echo $sql;
    $conn->query($sql);
    mysqli_close($conn);
}

function saveFile($filePath, $fileName, $opt = array())
{
    include_once(__DIR__ . '/oss/ALIOSS.php');
    $options = array(
        'bucket' => 'file-komovie-cn',
        'path' => 'ipa.cms_ios.' . date("Ym") . '.' . date("Ymd"),
        'url' => "http://file.komovie.cn"
    );
    $options = array_merge($options, $opt);
    $oss_sdk_service = new ALIOSS();
    $oss_sdk_service->set_debug_mode(FALSE);
    $response_upload_file_by_file = $oss_sdk_service->upload_file_by_file($options['bucket'], str_replace('.', '/', $options['path']) . '/' . $fileName, $filePath);
    // @unlink($filePath);

    if (is_null($options['url'])) {
        return $response_upload_file_by_file->header['_info']['url'];
    } else {
        return $options['url'] . '/' . str_replace('.', '/', $options['path']) . '/' . $fileName;
    }
}


?>
