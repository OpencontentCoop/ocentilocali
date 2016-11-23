<?php

class EntilocaliOperator
{

    /**
     * @var eZContentObjectTreeNode[]
     */
    public $nodes = array();

    private $ini;

    /**
     * @var eZTemplate
     */
    private $tpl;

    function EntilocaliOperator()
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
    ) {
        $this->tpl = $tpl;
        $this->nodes = $this->nodes();

        switch ($operatorName) {
            case 'siteaccess_identifier': {
                return $operatorValue = OpenPABase::getCurrentSiteaccessIdentifier();
            }
                break;

            case 'unit_measure': {
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

            case 'autofont': {
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

            case 'entelocale_node': {
                $nodes = $this->nodes;

                return $operatorValue = array_pop($nodes);
            }
                break;

            case 'entelocale_info': {
                $infoObject = false;
                $nodes = $this->nodes;
                /** @var eZContentObjectTreeNode[] $reverse */
                $reverse = array_reverse($nodes);
                foreach ($reverse as $node) {
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
                }

                return $operatorValue = $infoObject;
            }
                break;

            case 'entelocale_background': {
                $background = '';
                $nodes = $this->nodes;
                /** @var eZContentObjectTreeNode[] $reverse */
                $reverse = array_reverse($nodes);

                foreach ($reverse as $node) {
                    /** @var eZContentObjectAttribute[] $attributes */
                    $attributes = $node->attribute('object')->fetchAttributesByIdentifier(array('background'));
                    if (is_array($attributes)) {
                        foreach ($attributes as $attribute) {
                            if ($attribute->hasContent()) {
                                /** @var eZImageAliasHandler $image */
                                $image = $attribute->content();
                                //eZDebug::writeNotice($image->attributes(), __METHOD__ );
                                if ($image->hasAttribute('background')) {
                                    $backgroundObject = $image->attribute('background');
                                    //eZDebug::writeNotice( $backgroundObject, __METHOD__ );
                                    if (isset( $backgroundObject['full_path'] )) {
                                        $background = ' style="background-image: url(/' . $backgroundObject['full_path'] . ');"';
                                    }
                                }
                            }
                        }
                    }
                }

                return $operatorValue = $background;
            }
                break;

            case 'is_comune': {
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

            case 'is_comuni_folder': {
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

    /**
     * @return eZContentObjectTreeNode[]
     */
    private function nodes()
    {
        if (empty( $this->nodes )) {
            if ($this->tpl->hasVariable('module_result')) {
                $moduleResult = $this->tpl->variable('module_result');
            } else {
                $moduleResult = array();
            }
            $names = array();
            $nodes = array();
            $root = eZContentObjectTreeNode::fetch(eZINI::instance('content.ini')->variable('NodeSettings',
                'RootNode'));
            $path = ( isset( $moduleResult['path'] ) && is_array($moduleResult['path']) ) ? $moduleResult['path'] : array();
            $identifiers = $this->ini->hasVariable('SubSiteIdentifiers',
                'Identifiers') ? $this->ini->variable('SubSiteIdentifiers', 'Identifiers') : array();
            foreach ($path as $key => $item) {
                if (isset( $item['node_id'] )) {
                    $node = eZContentObjectTreeNode::fetch($item['node_id']);
                    if ($node && ( $item['node_id'] != 2 )
                        && in_array($node->attribute('class_identifier'), $identifiers)
                    ) {
                        $nodes[] = $node;
                        $names[] = $node->attribute('name');
                    }
                }
            }
            if (empty( $nodes )) {
                $nodes = array($root);
            }
            $this->nodes = $nodes;
        }

        return $this->nodes;
    }

}
