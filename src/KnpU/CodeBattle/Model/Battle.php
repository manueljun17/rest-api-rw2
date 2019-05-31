<?php

namespace KnpU\CodeBattle\Model;
use JMS\Serializer\Annotation as Serializer;
use Hateoas\Configuration\Annotation as Hateoas;

/**
 * @Hateoas\Relation(
 *      "programmer",
 *      href = @Hateoas\Route(
 *          "api_programmers_show",
 *          parameters = { "nickname" = "expr(object.programmer.nickname)" }
 *      ),
 *      embedded = "expr(object.programmer)"
 * )
 * @Serializer\ExclusionPolicy("all")
 */
class Battle
{
    /* All public properties are persisted */
    /**
     * @Serializer\Expose()
     */
    public $id;

    /**
     * @var Programmer
     */
    public $programmer;

    /**
     * @var Project
     */
    public $project;
    /**
     * @Serializer\Expose()
     */
    public $didProgrammerWin;
    /**
     * @Serializer\Expose()
     */
    public $foughtAt;
    /**
     * @Serializer\Expose()
     */
    public $notes;
    /**
     * @Serializer\VirtualProperty()
     */
    public function getProgrammerUri()
    {
        return '/api/programmers/'.$this->programmer->nickname;
    }
}
