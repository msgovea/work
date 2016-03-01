app.controller('ConfirmDeleteModalController', function ($scope, $uibModalInstance, event) {

    $scope.event = event;

    $scope.ok = function () {
        $uibModalInstance.close();
    };

    $scope.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
});