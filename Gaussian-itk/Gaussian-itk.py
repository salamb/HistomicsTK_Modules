# !/usr/bin/env python
# -*- coding: utf-8 -*-

###############################################################################
#  Copyright Kitware Inc.
#
#  Licensed under the Apache License, Version 2.0 ( the "License" );
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
###############################################################################

import sys
import logging

logging.basicConfig()
import itk
from itk import Image


from ctk_cli import CLIArgumentParser

# From https://itk.org/Doxygen/html/SphinxExamples_2src_2Filtering_2Smoothing
# _2SmoothWithRecursiveGaussian_2Code_8py-example.html
# and adapted to be used with histomics tk as a module
def main(namespace):

    inputImage = namespace.inputImage
    outputImage = namespace.outputImage
    sigma = float(namespace.sigma)


    ucPixelType= itk.UC

    Dimension = 2

    ImageType = Image[ucPixelType,Dimension]

    reader = itk.ImageFileReader[ImageType].New()
    reader.SetFileName(inputImage)


    smoothFilter = itk.SmoothingRecursiveGaussianImageFilter[
        ImageType,
        ImageType].New()
    smoothFilter.SetInput(reader.GetOutput())
    smoothFilter.SetSigma(sigma)

    writer = itk.ImageFileWriter[ImageType].New()
    writer.SetFileName(outputImage)
    writer.SetInput(smoothFilter.GetOutput())

    writer.Update()


if __name__ == "__main__":
    main(CLIArgumentParser().parse_args())
    
