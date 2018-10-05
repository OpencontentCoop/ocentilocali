<?php

class EntilocaliOperator
{

    /**
     * @var eZINI
     */
    private $ini;

    function __construct()
    {
        $this->Operators = self::Operators();
        $this->ini = eZINI::instance('entilocali.ini');
    }

    public static function Operators()
    {
        return array(
            'entelocale_background',
            'entelocale_info',
            'autofont',
            'is_comune',
            'is_comuni_folder',
            'unit_measure',
            'siteaccess_identifier'
        );
    }

    function operatorList()
    {
        return $this->Operators;
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array(
            'autofont' => array
            (
                'identifier' => array("type" => "string", "required" => false, "default" => "default")
            )
        );
    }

    function modify(
        &$tpl,
        &$operatorName,
        &$operatorParameters,
        &$rootNamespace,
        &$currentNamespace,
        &$operatorValue,
        &$namedParameters
    )
    {
        switch ($operatorName) {
            case 'siteaccess_identifier':
                {
                    return $operatorValue = OpenPABase::getCurrentSiteaccessIdentifier();
                }
                break;

            case 'unit_measure':
                {
                    $string = $operatorValue;
                    if (strpos($string, 'px') == false
                        && strpos($string, 'em') == false
                        && strpos($string, '%') == false
                        && strpos($string, 'pt') == false
                    ) {
                        return $operatorValue = $string . 'px';
                    }
                }
                break;

            case 'autofont':
                {
                    $count = strlen($operatorValue);
                    $identifier = $namedParameters['identifier'];
                    //eZDebug::writeNotice($count);
                    $fontsize = $this->ini->hasVariable('TitleSize',
                        $identifier . '_LengthSize') ? $this->ini->variable('TitleSize',
                        $identifier . '_LengthSize') : array();
                    //eZDebug::writeNotice($fontsize);
                    $dosize = 0;
                    foreach ($fontsize as $lenght => $size) {
                        if ($count > $lenght) {
                            $dosize = $size;
                        }
                    }
                    //eZDebug::writeNotice($dosize);
                    if ($dosize > 0) {
                        return $operatorValue = 'style="font-size:' . $dosize . 'px"';
                    }

                    return $operatorValue = false;
                }
                break;

            case 'entelocale_node':
                {
                    return $operatorValue = OpenPaFunctionCollection::fetchHome();
                }
                break;

            case 'entelocale_info':
                {
                    $infoObject = false;
                    $node = OpenPaFunctionCollection::fetchHome();

                    /** @var eZContentObjectAttribute[] $attributes */
                    $attributes = $node->attribute('object')->fetchAttributesByIdentifier(array('info'));
                    if (is_array($attributes)) {
                        foreach ($attributes as $attribute) {
                            if ($attribute->hasContent()) {
                                $infoObject = $node;
                                break;
                            }
                        }
                    }

                    return $operatorValue = $infoObject;
                }
                break;

            case 'entelocale_background':
                {
                    return $operatorValue = self::getEntLocaleBackground();
                }
                break;

            case 'is_comune':
                {
                    $node = $operatorValue;
                    $result = false;
                    if ($node instanceof eZContentObjectTreeNode) {
                        if ($node->attribute('class_identifier') == 'comune') {
                            $result = $node;
                        }
                    }

                    return $operatorValue = $result;
                }
                break;

            case 'is_comuni_folder':
                {
                    $node = $operatorValue;
                    $result = false;
                    if ($node instanceof eZContentObjectTreeNode
                        && OpenPAINI::variable('TopMenu', 'CustomMenuComuni', 'enabled') == 'enabled'
                    ) {
                        /** @var eZContentObjectTreeNode $child */
                        foreach ($node->attribute('children') as $child) {
                            if ($child->attribute('class_identifier') == 'comune') {
                                $result = $node;
                            }
                        }
                    }

                    return $operatorValue = $result;
                }
                break;
        }

        return false;
    }

    public static function getEntLocaleBackground()
    {
        return OpenPAPageData::getEntLocaleBackgroundCache()->processCache(
            function ($file) {
                $content = include($file);
                return $content;
            },
            function () {
                eZDebug::writeNotice("Regenerate header_logo cache", 'OpenPaFunctionCollection::fetchHeaderLogoStyle');
                $result = '';

                $node = OpenPaFunctionCollection::fetchHome();

                /** @var eZContentObjectAttribute[] $attributes */
                $attributes = $node->attribute('object')->fetchAttributesByIdentifier(array('background'));
                if (is_array($attributes)) {
                    foreach ($attributes as $attribute) {
                        if ($attribute->hasContent()) {
                            /** @var eZImageAliasHandler $image */
                            $image = $attribute->content();

                            if ($image->hasAttribute('entilocali_background')) {
                                $backgroundObject = $image->attribute('entilocali_background');

                                if (isset($backgroundObject['full_path'])) {
                                    $result = ' style="background-image: url(/' . $backgroundObject['full_path'] . ');"';
                                }
                            }
                        }
                    }
                }

                return array(
                    'content' => $result,
                    'scope' => 'cache',
                    'datatype' => 'php',
                    'store' => true
                );
            }
        );
    }
}
