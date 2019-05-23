<?php
// src/KnpU/CodeBattle/Api/ApiProblemResponseFactory.php
namespace KnpU\CodeBattle\Api;

use Symfony\Component\HttpFoundation\JsonResponse;
use KnpU\CodeBattle\Api\ApiProblem;
class ApiProblemResponseFactory
{
	public function createResponse(ApiProblem $apiProblem)
    {
        $data = $apiProblem->toArray();
        // making type a URL, to a temporarily fake page
        if ($data['type'] != 'about:blank') {
            $data['type'] = 'http://localhost:8000/api/docs/errors#'.$data['type'];
        }
        $response = new JsonResponse(
            $data,
            $apiProblem->getStatusCode()
        );
        $response->headers->set('Content-Type', 'application/problem+json');

        return $response;
    }
}